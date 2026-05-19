{ config, pkgs, inputs, ... }:

{
  # Core Home Manager Settings
  home.username = "haakez";
  home.homeDirectory = "/home/haakez";
  home.stateVersion = "25.11";

imports = [ 
    inputs.textfox.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default # <-- Add this line
  ];
xdg.configFile = {
    "waybar".source = ./dotfiles/waybar;
    "mako".source = ./dotfiles/mako;
    "kitty".source = ./dotfiles/kitty;
    "fastfetch".source = ./dotfiles/fastfetch;
    "fuzzel".source = ./dotfiles/fuzzel;
    "btop".source = ./dotfiles/btop;
    "cava".source = ./dotfiles/cava;
    "fish".source = ./dotfiles/fish;
    "qt5ct".source = ./dotfiles/qt5ct;
    "qt6ct".source = ./dotfiles/qt6ct;
    "niri".source = ./dotfiles/niri;
    
  };
    programs.firefox.configPath = ".mozilla/firefox";
    textfox = {
    enable = true;
    profiles = [ "haakez" ];
    config = {
      # We will customize this later!
    };
   
  };
programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      
      # The "text" theme is the official name for spicetify-tui
      theme = spicePkgs.themes.text;
      
      # You can add extensions here later, like adblock!
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
      ];
    };
  home.packages = with pkgs; [
    firefox
    vesktop
    telegram-desktop

    mpv
    imv
    cava
    mangohud

    kitty
    neovim
    micro
    vscode

    fastfetch
    btop
    yazi
    kdePackages.dolphin
    kdePackages.ark
    pavucontrol

    waybar
    swaybg
    fuzzel
    wallust
    mako
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

  programs.home-manager.enable = true;
}
