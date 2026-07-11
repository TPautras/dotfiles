{ self, inputs, ... }: {
  flake.homeManagerModules.obsidian = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.obsidian;
  in {
    options.hm.obsidian.enable = mkEnableOption "Obsidian note-taking app";

    config = mkIf cfg.enable {
      home.packages = with pkgs; [
        obsidian
      ];

      xdg.configFile."obsidian/obsidian.json".text = builtins.toJSON {
        version  = "1.4.16";
        basePath = "${config.home.homeDirectory}/.obsidian/vault";
      };
    };
  };
}
