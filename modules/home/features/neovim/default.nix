{ self, inputs, ... }: {
  flake.homeManagerModules.neovim = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.neovim;
  in {
    options.hm.neovim.enable = mkEnableOption "Neovim + LazyVim (Python, Lua, C++)";

    config = mkIf cfg.enable {
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

      xdg.configFile."nvim/init.lua".text = ''
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not (vim.uv or vim.loop).fs_stat(lazypath) then
          vim.fn.system({
            "git", "clone", "--filter=blob:none", "--branch=stable",
            "https://github.com/folke/lazy.nvim.git", lazypath,
          })
        end
        vim.opt.rtp:prepend(lazypath)

        require("lazy").setup({
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            { import = "lazyvim.plugins.extras.lang.python" },
            { import = "lazyvim.plugins.extras.lang.lua" },
            { import = "lazyvim.plugins.extras.lang.clangd" },
            { import = "lazyvim.plugins.extras.lang.nix" },
            { import = "plugins" },
          },
          defaults  = { lazy = false, version = false },
          install   = { colorscheme = { "everforest", "habamax" } },
          checker   = { enabled = true, notify = false },
          performance = {
            rtp = {
              disabled_plugins = {
                "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin",
              },
            },
          },
        })
      '';

      xdg.configFile."nvim/lua/plugins/colorscheme.lua".text = ''
        return {
          {
            "sainnhe/everforest",
            lazy     = false,
            priority = 1000,
            config   = function()
              vim.g.everforest_background         = "hard"
              vim.g.everforest_better_performance = 1
              vim.g.everforest_enable_italic      = 1
              vim.cmd.colorscheme("everforest")
            end,
          },
          {
            "LazyVim/LazyVim",
            opts = { colorscheme = "everforest" },
          },
        }
      '';

      xdg.configFile."nvim/lua/plugins/options.lua".text = ''
        return {
          {
            "nvim-lspconfig",
            opts = {
              servers = {
                pyright = {},
                lua_ls  = {},
                clangd  = {},
                nil_ls  = {},
              },
            },
          },
        }
      '';

      xdg.configFile."nvim/lua/plugins/.keep".text = "";
    };
  };
}
