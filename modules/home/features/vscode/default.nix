{ self, inputs, ... }: {
  flake.homeManagerModules.vscode = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.vscode;
    nvim =
      if config.programs.neovim.enable
      then "${config.programs.neovim.finalPackage}/bin/nvim"
      else "${pkgs.neovim}/bin/nvim";
  in {
    options.hm.vscode.enable = mkEnableOption "Visual Studio Code";

    config = mkIf cfg.enable {
      programs.vscode = {
        enable = true;

        profiles.default = {
          extensions = with pkgs.vscode-extensions; [
            asvetliakov.vscode-neovim
            ms-python.python
            ms-toolsai.jupyter
            charliermarsh.ruff
            jnoortheen.nix-ide
            ms-vscode.cpptools
            esbenp.prettier-vscode
            mkhl.direnv
          ];

          userSettings = {
            "editor.fontLigatures" = true;
            "editor.formatOnSave"  = true;
            "files.trimTrailingWhitespace" = true;

            "window.titleBarStyle" = "custom";

            "extensions.autoUpdate"      = false;
            "extensions.autoCheckUpdates" = false;
            "update.mode"                = "none";
            "telemetry.telemetryLevel"   = "off";

            "vscode-neovim.neovimExecutablePaths.linux" = nvim;

            "nix.enableLanguageServer" = true;
            "nix.serverPath"           = "${pkgs.nil}/bin/nil";

            "python.defaultInterpreterPath" = "${pkgs.python3}/bin/python3";
          };
        };
      };
    };
  };
}
