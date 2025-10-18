{
  description = ''
    The average electrician config
  '';

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    hyprland.url = "github:hyprwm/Hyprland";
    hyprpanel = {
      url = "github:Jas-SinghFSU/HyprPanel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, home-manager, nixpkgs, chaotic, hyprland, hyprpanel, ... }@inputs:
    let
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages =
        forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = {
        jade = nixpkgs.lib.nixosSystem {
          specialArgs = { 
            inherit inputs outputs;
            host ="jade"; 
          };
          modules = [ 
            ./hosts/jade 
            chaotic.nixosModules.default
          ];
        };
      };
      homeConfigurations = {
        "thomas@jade" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { 
            inherit inputs outputs; 
            host = "jade";
          };
          modules = [ 
            ./hosts/jade/home.nix 
            hyprpanel.homeManagerModules.hyprpanel
          ];
        };
      };
    };
}
