{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options= "--delete-older-than 7d";
  };
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.cnijfilter2 ];
systemd.services.simple-input-overlay = {
  description = "Simple Input Overlay Event Server";
  
  # Ensure the service starts after the graphical display/input devices are ready
  after = [ "network.target" "multi-user.target" ];
  wantedBy = [ "multi-user.target" ];

  serviceConfig = {
    Type = "simple";
    
    # Run as root to ensure it can access /dev/input/event*
    User = "root"; 
    
    # Run inside a Python environment configured with the required packages
    ExecStart = let
      # Create a custom python wrapper with the required packages
      pythonEnv = pkgs.python3.withPackages (ps: with ps; [ websockets evdev ]);
    in "${pythonEnv}/bin/python /home/haakez/simple-input-overlay/server.py";

    # Restart behavior if the script crashes
    Restart = "always";
    RestartSec = "3s";
  };
  
  # Inject nixpkgs dependencies if needed
  path = [ pkgs.python3 ];
};

  # --- BOOT,HARDWARE ---
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.theme = pkgs.minimal-grub-theme;

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.blacklistedKernelModules = [ "amdgpu" "radeon" ];
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "udev.log_level=3" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.localBinInPath = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
programs.dconf.enable = true;
  # Custom Mouse Acceleration
  services.udev.extraHwdb = ''
    evdev:name:*
      LIBINPUT_ATTR_ACCEL_PROFILE_HINT=custom
      LIBINPUT_ATTR_ACCEL_POINTS_MOTION=0.000;0.079;0.159;0.274;0.393;0.512;0.632;0.804;0.985;1.167;1.348;1.529;1.711;1.892;2.074;2.255;2.436;2.618;2.799;2.981;3.355
      LIBINPUT_ATTR_ACCEL_STEP_MOTION=0.2031610269
  '';
   environment.etc."libinput/local-overrides.quirks".text = ''
     [Logitech G502 X PLUS Wireless]
     MatchName=*Logitech G502 X PLUS*
     AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
   '';
  networking.hostName = "nixos";
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
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd \"env QT_QPA_PLATFORMTHEME=qt6ct GTK_THEME=Adwaita:dark niri-session\"";
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
  
  programs.gamemode.enable = true;
  programs.niri.enable = true;
  programs.fish.enable = true;
  # --- ENVIRONMENT,USER ---
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GTK_THEME = "Adwaita:dark";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
  environment.sessionVariables = {
    QT_STYLE_OVERRIDE = "Breeze-Dark";
  };
  environment.systemPackages = with pkgs; [
      git
      fish
      python3
      nautilus
      bubblewrap
    ];

  nixpkgs.config.allowUnfree = true;

  users.users.haakez = {
    isNormalUser = true;
    description = "haakez";
    extraGroups = [ "networkmanager" "wheel" "input" ];
    shell = pkgs.fish;
  };
  fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      jetbrains-mono
    ];

  system.stateVersion = "25.11"; 
}
