{ self, inputs, ... }: {
  flake.homeManagerModules.nixvim =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    with lib;
    let
      cfg = config.hm.nixvim;
    in
    {
      options.hm.nixvim.enable = mkEnableOption "Nixvim option";

      config = mkIf cfg.enable {
        programs.nixvim.enable = true;
      };
    };
}
