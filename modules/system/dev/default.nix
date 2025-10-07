{ lib, config, pkgs, pkgs-stable, ... }:
let cfg = config.systemSettings.dev;
in {
  options.systemSettings.dev = {
    enable = lib.mkEnableOption "Developer toolchains (system-wide)";
    go = {
      enable = lib.mkOption { type = lib.types.bool; default = false; };
      package = lib.mkOption { type = lib.types.package; default = pkgs.go; };
      extras = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ pkgs.gopls pkgs.golangci-lint ];
      };
    };
    node = {
      enable = lib.mkOption { type = lib.types.bool; default = false; };
      package = lib.mkOption { type = lib.types.package; default = pkgs.nodejs_20; };
      managers = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ pkgs.pnpm pkgs.yarn ];
      };
    };
    python = {
      enable = lib.mkOption { type = lib.types.bool; default = false; };
      package = lib.mkOption { type = lib.types.package; default = pkgs.python312; };
      extras = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ pkgs.python312Packages.pip pkgs.uv ];
      };
    };
    texlive = {
      enable = lib.mkOption { type = lib.types.bool; default = false; };
      flavor = lib.mkOption {
        type = lib.types.enum [ "small" "medium" "full" ];
        default = "full";
        description = "Pick TeX Live size (full uses scheme-full).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      (lib.optionals cfg.go.enable ( [ cfg.go.package ] ++ cfg.go.extras )) ++
      (lib.optionals cfg.node.enable ( [ cfg.node.package ] ++ cfg.node.managers )) ++
      (lib.optionals cfg.python.enable ( [ cfg.python.package ] ++ cfg.python.extras )) ++
      (lib.optionals cfg.texlive.enable [
        (if cfg.texlive.flavor == "full" then pkgs.texlive.combined.scheme-full
         else if cfg.texlive.flavor == "medium" then pkgs.texlive.combined.scheme-medium
         else pkgs.texlive.combined.scheme-small)
      ]);
  };
}
