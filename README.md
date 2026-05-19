# хейкез's NixOS Configuration

![Screenshot](https://cdn.discordapp.com/attachments/1150468182805577829/1503368775544737823/image.png?ex=6a0da4c7&is=6a0c5347&hm=b5545844a1fb53050aef39e6d5f581712764442ba911c86bee613356fe0b9c1d&)

## System Components

* **OS:** NixOS (Unstable)
* **Compositor:** Niri 
* **Shell:** Fish
* **Terminal:** Kitty
* **Bar:** Waybar
* **Browser:** Firefox (Textfox)
* **Launcher:** Fuzzel
* **Notifications:** Mako

## Usage

To rebuild, run:

```bash
sudo nixos-rebuild switch --flake .#nixos


nixos-configuration/
├── flake.nix                 
├── home.nix                  
├── hosts/
│   └── nixos/
│       ├── configuration.nix 
│       └── hardware-configuration.nix
└── dotfiles/                 
    ├── niri/
    ├── waybar/
    ├── kitty/
    └── ...
