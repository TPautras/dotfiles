{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  # Packages available in the shell
  packages = with pkgs; [
    git
    nix # Ensures Nix with Flakes support is available
    nix-command # Provides 'nix' command-line interface
    nixos-install # For installing NixOS (if applicable)
    disko # For disk partitioning and formatting (if using disko)
  ];

  # Environment variables (optional)
  shellHook = ''
    echo "Welcome to your Nix Flake bootstrapping shell!"
    echo "Remember to enable flakes in your nix.conf if you haven't already:"
    echo "experimental-features = nix-command flakes"
  '';
}