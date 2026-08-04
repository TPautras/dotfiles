{ self, inputs, ... }: {
  flake.homeManagerModules.neovim = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.neovim;
  in {
    options.hm.neovim = {
      enable = mkEnableOption "Neovim + LazyVim (Python, Lua, C++, Nix)";

      configDir = mkOption {
        type    = types.str;
        default = "${config.home.homeDirectory}/nvim-config";
        description = "Repo LazyVim autonome, lié hors du store et éditable en place.";
      };
    };

    config = mkIf cfg.enable {
      home.sessionVariables.NVIM_NIX = "1";

      programs.neovim = {
        enable        = true;
        defaultEditor = true;
        viAlias       = true;
        vimAlias      = true;
        withPython3   = true;
        withNodeJs    = true;
        withRuby      = false;

        extraPackages = with pkgs; [
          pyright
          python3Packages.black
          python3Packages.isort
          ruff

          lua-language-server
          stylua

          clang-tools
          cmake-language-server
          gcc
          cmake
          gnumake

          nil
          nixfmt
          prettier
          ripgrep
          fd
          lazygit
          tree-sitter
        ];
      };

      xdg.configFile."nvim".source =
        config.lib.file.mkOutOfStoreSymlink cfg.configDir;

      xdg.configFile."nvim/init.lua".enable = mkForce false;
    };
  };
}
