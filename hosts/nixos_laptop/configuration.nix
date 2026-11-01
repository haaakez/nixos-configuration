{ config, pkgs, inputs, ... }:

  let
    codexCustom = pkgs.stdenvNoCC.mkDerivation {
      pname = "codex";
      version = "0.166.0";

      src = pkgs.fetchurl {
        url = "https://registry.npmjs.org/@openai/codex/-/codex-0.166.0-linux-x64.tgz";
        hash = "sha256-y8AKJtPQ4s7vxL6IkfioHvHjSbOxdbwK4wh2K8AB/ZM=";
      };

      sourceRoot = "package";
      dontConfigure = true;
      dontBuild = true;
      dontCheck = true;

      installPhase = ''
        vendor="$out/libexec/codex/vendor/x86_64-unknown-linux-musl"
        mkdir -p "$vendor" "$out/bin"
        cp -R vendor/x86_64-unknown-linux-musl/. "$vendor/"
        chmod +x "$vendor/bin/codex" "$vendor/bin/codex-code-mode-host"
        ln -s "$vendor/bin/codex" "$out/bin/codex"
        ln -s "$vendor/bin/codex-code-mode-host" "$out/bin/codex-code-mode-host"
      '';
    };
  in
  {


  imports = [ ./hardware-configuration.nix ];

  services.tlp = {
    enable = true;
    settings.CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  };
  services.power-profiles-daemon.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options= "--delete-older-than 7d";
  };
hardware.graphics.extraPackages = [ pkgs.rocmPackages.clr.icd ];
  # --- BOOT,HARDWARE ---
  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    theme = pkgs.minimal-grub-theme;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "udev.log_level=3" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

boot.extraModprobeConfig = ''
	options rtw89_pci disable_aspm=y
'';

  # Custom Mouse Acceleration
  services.udev.extraHwdb = ''
    evdev:name:*
      LIBINPUT_ATTR_ACCEL_PROFILE_HINT=custom
      LIBINPUT_ATTR_ACCEL_POINTS_MOTION=0.000;0.079;0.159;0.274;0.393;0.512;0.632;0.804;0.985;1.167;1.348;1.529;1.711;1.892;2.074;2.255;2.436;2.618;2.799;2.981;3.355
      LIBINPUT_ATTR_ACCEL_STEP_MOTION=0.2031610269
  '';

  # --- LOCALIZATION,NETWORKING ---
  networking.hostName = "nixos-laptop";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Sofia";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "bg_BG.UTF-8";
    LC_IDENTIFICATION = "bg_BG.UTF-8";
    LC_MEASUREMENT = "bg_BG.UTF-8";
    LC_MONETARY = "bg_BG.UTF-8";
    LC_NAME = "bg_BG.UTF-8";
    LC_NUMERIC = "bg_BG.UTF-8";
    LC_PAPER = "bg_BG.UTF-8";
    LC_TELEPHONE = "bg_BG.UTF-8";
    LC_TIME = "bg_BG.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us,ua,ru";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  # --- CORE SERVICES,SYSTEM PROGRAMS ---
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd \"env QT_QPA_PLATFORMTHEME=qt6ct niri-session\"";
        user = "greeter";
      };
    };
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true; 
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };
  programs.obs-studio = {
  	enable=true;
  	package=(pkgs.obs-studio.override { cudaSupport = true; });
  	plugins = with pkgs.obs-studio-plugins; [
  		wlrobs
  		obs-pipewire-audio-capture
  		obs-vkcapture
  	];
  };
  services.flatpak.enable = true;
  services.flatpak.remotes = [{ name = "flathub"; location = "https://flathub.org"; }];
  services.flatpak.packages = [ "flathub;org.vinegarhq.Sober" ];
  programs.dconf.enable = true;
  programs.gamemode.enable = true;
  programs.niri.enable = true;
  programs.fish.enable = true;
  # --- ENVIRONMENT,USER ---
environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "Breeze-Dark";
    # Force GTK to use the Catppuccin theme and Tela icons
    GTK_THEME = "Graphite-Mono";
  };
environment.systemPackages = with pkgs; [
      config.home-manager.users.haakez.gtk.theme.package
      git
      gcc
      gpp
      nautilus
      fish
      python3
      nemo-with-extensions
      tela-icon-theme
      nwg-look 
      codexCustom
      bubblewrap
      brightnessctl
      swayidle
      powertop
    ];
  nixpkgs.config.allowUnfree = true;

  users.users.haakez = {
    isNormalUser = true;
    description = "haakez";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };
  fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      jetbrains-mono
    ];

  system.stateVersion = "25.11"; 
}
