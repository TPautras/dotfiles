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
  };

  outputs = { self, home-manager, nixpkgs, ... }@inputs:
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
          modules = [ ./hosts/jade ];
        };
      };
      homeConfigurations = {
        "thomas@jade" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { 
            inherit inputs outputs; 
            host = "jade";
          };
          modules = [ ./hosts/jade/home.nix ];
        };
      };
    };
}
