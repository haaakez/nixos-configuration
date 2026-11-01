# haakez's nixos config



my nixos config built with home-manager, which uses niri as its compositor

![desktop screenshot](media/screenshot.png)

![desktop preview](media/preview.gif)

## system components

- **OS:** NixOS
- **compositor:** Niri
- **shell:** Fish
- **terminal:** Kitty
- **bar:** Waybar
- **browser:** Firefox
- **file manager:** Nautilus
- **launcher:** Fuzzel
- **notifications:** Fnott
- **system monitor:** btop

## structure

```text
nixos-configuration/
├── flake.nix
├── flake.lock
├── home.nix             # desktop home config(dont ask why its here)
├── hosts/
│   ├── nixos/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── nixos_laptop/
│       ├── configuration.nix
│       ├── hardware-configuration.nix
│       └── home.nix
├── dotfiles/
│   ├── nixos/
│   │   ├── niri/
│   │   ├── waybar/
│   │   ├── kitty/
│   │   ├── gtk-theme/
│   │   └── ...
│   └── nixos_laptop/
│       ├── niri/
│       ├── waybar/
│       ├── kitty/
│       ├── gtk-theme/
│       ├── cava/
│       ├── vesktop-theme.css
│       └── ...
├── Wallpapers/
└── media/
```

### nix files

- **`flake.nix`** defines the flake inputs and my hosts
- **`flake.lock`** locks the versions of the flake inputs
- **`home.nix`** defines the packages i use, also has some scripts and firefox/spicetifytui styling
- **`hosts/nixos/configuration.nix`** the unique thing here is that it has a custom scroll wheel and mouse accel, other than that it just has the drivers and some important pkgs
- **`hosts/nixos_laptop/`** contains the laptop-specific system, hardware, and home configuration
- **`hardware-configuration.nix`** in each host contains its disk and hardware settings, generate a new one for a different machine

### dotfiles

both hosts have their own directories under `dotfiles/`, application settings are linked into `~/.config/` through home-manager

- **`niri/`** - window layout, rules, binds
- **`waybar/`** - the waybar config
- **`kitty/`** - terminal font, colors, and opacity
- **`fuzzel/`** - application launcher
- **`fnott/`** - notifications
- **`btop/`** - system monitor
- **`fastfetch/`** - terminal system information
- **`gtk-theme/`** - custom GTK3 and GTK4 theme
- **`qt5ct/`** and **`qt6ct/`** - qt6 and qt5 configs(i dont know why they still exist, they are useless and im too lazy to delete them)

### other

**laptop config look:**

![Laptop configuration look](media/laptop-screenshot.png)

the **`Wallpapers/`** folder contains my... wallpapers, theyre pretty decent
  
if you want to actually install the config, then:
```bash
git clone https://github.com/haaakez/nixos-configuration
cd nixos-configuration  # you might probably also want to replace the hardware config with the pre-generated config
```

Apply the configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos         # desktop
sudo nixos-rebuild switch --flake .#nixos_laptop  # laptop
```