{
  description = "Thomas NixOS config — laptops Jade & Cobble. Le serveur Granite tourne sous Ubuntu (voir ./granite).";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    walt.url = "github:gitfudge0/walt";

    stylix.url = "github:danth/stylix/release-25.05";

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    areofyl-fetch.url = "github:areofyl/fetch";

    # Hyprland from the flake so plugins can be built against the exact same
    # source (ABI match). nixpkgs is intentionally NOT followed here, so we keep
    # hyprland's own cachix binary cache instead of rebuilding from source.
    hyprland.url = "github:hyprwm/Hyprland";

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    hypr-dynamic-cursors = {
      url = "github:VirtCode/hypr-dynamic-cursors";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake
    { inherit inputs; }
    (inputs.import-tree ./modules);
}
