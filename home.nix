{ config, pkgs, inputs, ... }:

{
  home.username = "haakez";
  home.homeDirectory = "/home/haakez";
  home.stateVersion = "25.11";

imports = [ 
    inputs.textfox.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
  ];
xdg.configFile = {
    "waybar".source = ./dotfiles/waybar;
    "fnott".source = ./dotfiles/fnott;
    "kitty".source = ./dotfiles/kitty;
    "fastfetch".source = ./dotfiles/fastfetch;
    "fuzzel".source = ./dotfiles/fuzzel;
    "btop".source = ./dotfiles/btop;
    "qt5ct".source = ./dotfiles/qt5ct;
    "qt6ct".source = ./dotfiles/qt6ct;
    "niri".source = ./dotfiles/niri;
    
    
  };
programs.firefox.profiles."haakez".settings = {
    "widget.wayland.transparent-background" = true;
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "gfx.webrender.all" = true;
  };
    programs.firefox.configPath = ".mozilla/firefox";
  textfox = {
    enable = true;
    profiles = [ "haakez" ]; 
    
};home.file.".mozilla/firefox/haakez/chrome/userChrome.css".source = ./dotfiles/firefox/userChrome.css;
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
              main = "000000";        
              sidebar = "000000";     
              player = "000000";       
              card = "111111";         
              shadow = "000000";       
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
    programs.micro = {
      enable = true;
      settings = {
        colorscheme = "simple";
      };
    };
  home.packages = with pkgs; [
  	nodejs_24
    firefox
    vesktop
    telegram-desktop

    mpv
    imv
    cava
    mangohud

    kitty
    neovim
    vscode
    darktable
    gimp
    gphoto2
    unityhub
    

    fastfetch
    btop
    yazi
    kdePackages.dolphin
    kdePackages.ark
    kdePackages.kdenlive
    pavucontrol
    cmatrix
    peaclock

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
      WALL_DIR="$HOME/Pictures/Wallpapers"
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
  programs.fish.shellAliases = {
      gemini = "npx --yes @google/gemini-cli";
    };

  programs.home-manager.enable = true;
}
