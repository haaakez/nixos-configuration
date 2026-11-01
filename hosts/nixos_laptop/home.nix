{ config, pkgs, inputs, ... }:
	
{
  home.username = "haakez";
  home.homeDirectory = "/home/haakez";
  home.file.".vscode-oss/extensions/haakez.graphite-mono-1.0.0".source = ../../dotfiles/nixos_laptop/vscodium-theme;
  xdg.configFile."vesktop/themes/system24-laptop-graphite.theme.css".source = ../../dotfiles/nixos_laptop/vesktop-theme.css;
  home.stateVersion = "25.11";
  home.sessionPath = [ "$HOME/.local/bin" ];

imports = [ 
    inputs.spicetify-nix.homeManagerModules.default
  ];
xdg.configFile = {
    "cava/config" = { source = ../../dotfiles/nixos_laptop/cava/config; force = true; };
    "waybar".source = ../../dotfiles/nixos_laptop/waybar;
    "fnott".source = ../../dotfiles/nixos_laptop/fnott;
    "kitty".source = ../../dotfiles/nixos_laptop/kitty;
    "fastfetch".source = ../../dotfiles/nixos_laptop/fastfetch;
    "fuzzel".source = ../../dotfiles/nixos_laptop/fuzzel;
    "btop".source = ../../dotfiles/nixos_laptop/btop;
    "qt5ct".source = ../../dotfiles/nixos_laptop/qt5ct;
    "qt6ct".source = ../../dotfiles/nixos_laptop/qt6ct;
    "niri".source = ../../dotfiles/nixos_laptop/niri;
    
    
  };

    gtk = {
      enable = true;
      theme = {
        name = "Graphite-Mono";
        package = pkgs.runCommand "graphite-mono-gtk-theme" {} ''
          mkdir -p "$out/share/themes"
          cp -r ${../../dotfiles/nixos_laptop/gtk-theme} "$out/share/themes/Graphite-Mono"
        '';
      };
      gtk4.theme = config.gtk.theme;
      font = {
        name = "JetBrains Mono";
        size = 11;
      };
      iconTheme = {
        name = "Papirus-Dark"; # Or "Adwaita" if you prefer
        package = (pkgs.papirus-icon-theme.override { color = "violet"; }).overrideAttrs { dontFixup = true; };
      };
    };
  
programs.firefox.enable = true;
programs.firefox.profiles."haakez".settings = {
    "widget.wayland.transparent-background" = false;
    "widget.transparent-windows" = false;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "gfx.webrender.all" = true;
  };
    programs.firefox.configPath = ".mozilla/firefox";
  programs.firefox.profiles."haakez".userChrome = ''
    *, *::before, *::after {
      font-family: "JetBrains Mono", monospace !important;
      font-size: 11pt !important;
      border-radius: 0 !important;
    }

    :root {
      --lwt-accent-color: #090909 !important;
      --lwt-accent-color-inactive: #090909 !important;
      --toolbar-bgcolor: #090909 !important;
      --toolbar-background-color: #090909 !important;
      --panel-background: #090909 !important;
      --panel-color: #ffffff !important;
      --sidebar-border-color: #141414 !important;
      color: #ffffff !important;
    }

    :root, window, body {
      background: #090909 !important;
      appearance: none !important;
    }

    #navigator-toolbox, #sidebar-box, #sidebar-main {
      background: #090909 !important;
      color: #ffffff !important;
      appearance: none !important;
    }

    #navigator-toolbox toolbar, #TabsToolbar, #nav-bar, #PersonalToolbar,
    .browser-toolbox-background {
      background: #090909 !important;
      background-image: none !important;
      appearance: none !important;
    }

    #sidebar-main, #sidebar-box, #sidebar-splitter, #sidebar-launcher-splitter, #vertical-tabs {
      border: 0 !important;
      box-shadow: none !important;
      outline: none !important;
    }

    #sidebar-launcher-splitter {
      display: none !important;
    }

    menupopup, panel, .panel-arrowcontent {
      --panel-background: #090909 !important;
      --panel-color: #ffffff !important;
    }
  '';
  programs.firefox.profiles."haakez".settings = {
    "sidebar.revamp" = true;
    "sidebar.verticalTabs" = true;
    "sidebar.visibility" = "always-show";
    "browser.toolbars.bookmarks.visibility" = "never";
  };
programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      
      theme = spicePkgs.themes.text;
    
            colorScheme = "custom"; 
            
            
            customColorScheme = {
              text = "ffffff";         
              subtext = "999999";      
              main = "090909";        
              sidebar = "090909";     
              player = "090909";       
              card = "111111";         
              shadow = "090909";       
              selectedRow = "222222";   
              button = "ffffff";   
              buttonActive = "cccccc";
              buttonDisabled = "444444";
              tabActive = "222222";  
              notification = "111111"; 
              notificationError = "ffffff"; 
              misc = "333333";
            };
      

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
      ];
    };
    home.file.".local/share/icons/Papirus-Dark".source = "${config.gtk.iconTheme.package}/share/icons/Papirus-Dark";
    home.file.".local/share/themes/Graphite-Mono".source = "${config.gtk.theme.package}/share/themes/Graphite-Mono";
    dconf.settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
      };
    programs.micro = {
      enable = true;
      settings = {
        colorscheme = "simple";
      };
    };
  home.packages = with pkgs; [
  	nodejs_24
    vesktop
    telegram-desktop

    mpv
    imv
    cava
    mangohud

    kitty
    neovim
    vscodium
    darktable
    gimp
    gphoto2
    unityhub
    gamescope
	    fastfetch
    btop
    yazi
    kdePackages.ark
    kdePackages.kdenlive
    pavucontrol
    cmatrix
    peaclock
    prismlauncher

    waybar
    swaybg
    fuzzel
    wallust
    fnott
    polkit_gnome
    wl-clipboard
    cliphist
    grim
    slurp
    xwayland-satellite
    libnotify

    kdePackages.breeze
    kdePackages.qt6ct
    libsForQt5.qt5ct
    gemini-cli


    # 1. Microphone Toggle Script
    (writeShellScriptBin "toggle-mic" ''
      ${wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

      if ${wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"; then
          ${libnotify}/bin/notify-send "Microphone" "DISABLED"
      else
          ${libnotify}/bin/notify-send "Microphone" "ENABLED"
      fi
    '')

    # 2. Dynamic Wallpaper Picker
    (writeShellScriptBin "wallpicker" ''
      WALL_DIR="$HOME/nixos-configuration/Wallpapers"
      TMP_FILE="/tmp/wall_picker_target"
      CACHE_FILE="$HOME/.cache/current_wallpaper"

      ${kitty}/bin/kitty --class "wall-picker" -e ${yazi}/bin/yazi "$WALL_DIR" --chooser-file="$TMP_FILE"

      if [ -s "$TMP_FILE" ]; then
          SELECTED=$(cat "$TMP_FILE")
          echo "$SELECTED" > "$CACHE_FILE"
          
          ${psmisc}/bin/killall swaybg 2>/dev/null || true
          ${swaybg}/bin/swaybg -i "$SELECTED" -m fill &
          
          rm "$TMP_FILE"
      fi
    '')
  ];
  xdg.configFile."fish/config.fish".text = ''
    if status is-interactive
      ${pkgs.fastfetch}/bin/fastfetch --config "$HOME/.config/fastfetch/tui.jsonc"
    end
  '';
  programs.fish.shellAliases = {
      gemini = "npx --yes @google/gemini-cli";
    };

  programs.home-manager.enable = true;
}
