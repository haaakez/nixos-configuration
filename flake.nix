{
  description = "Haakez Niri Flake System";

  inputs = {
    # The official NixOS package source
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home Manager, locked to the same packages as your system
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	    zen-browser = {
	      url = "github:youwen5/zen-browser-flake";
	      inputs.nixpkgs.follows = "nixpkgs";
	    };

	
    # The Textfox theme repository
    textfox.url = "github:adriankarlen/textfox";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: {
    nixosConfigurations = {
      # This MUST match your system's hostname!
      "nixos" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        
        modules = [
          ./hosts/nixos/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            
            home-manager.users.haakez = import ./home.nix;
          }
        ];
      };
    };
  };
}
