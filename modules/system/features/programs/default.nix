{ self, inputs, ... }: {
  flake.nixosModules.programs = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.sys.programs;
  in {
    options.sys.programs.enable = mkEnableOption "base system CLI programs";

    config = mkIf cfg.enable {
      programs = {
        fish.enable = true;
        git.enable  = true;
        nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
          flake = "/home/thomas/.dotfiles";
        };
      };
      environment.systemPackages = with pkgs; [
        vim
        git 
        curl 
        wget 
        unzip 
        p7zip 
        file 
        which 
        fastfetch
        yazi 
        rustup 
        spotatui
        inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
  };
}
