{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
  };

  outputs = inputs@{ nixpkgs, home-manager, zen-browser, nixos-hardware, ... }: {
    nixosConfigurations = {
      sauls-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix

          # Hardware specific configuration for Framework 13
          nixos-hardware.nixosModules.framework-amd-ai-300-series

          # Home Manager module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            # Make all flake inputs (including zen-browser) available to home.nix
            home-manager.extraSpecialArgs = { inherit inputs; };            

            home-manager.users.saul = import ./home.nix;
          }
        ];
      };
    };
  };
}