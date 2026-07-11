{ self, inputs, ... }: {
  flake.homeManagerModules.fish = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.fish;
  in {
    options.hm.fish.enable = mkEnableOption "Fish shell + abbréviations";

    config = mkIf cfg.enable {
      programs.fish = {
        enable = true;
        loginShellInit = ''
          set -x TERMINAL kitty
          set -x EDITOR   nvim
          set -x VISUAL   nvim
          pokemon-colorscripts --no-title -r
        '';
        shellAbbrs = {
          ".."   = "cd ..";
          "..."  = "cd ../..";
          ls     = "eza --icons --group-directories-first";
          ll     = "eza -la --icons --group-directories-first --git";
          la     = "eza -a --icons";
          lt     = "eza --tree --icons --level=2";
          cat    = "bat";
          grep   = "rg";
          ps     = "procs";
          top    = "htop";
          df     = "duf";
          du     = "dust";
          mkdir  = "mkdir -p";
          g      = "git";
          ga     = "git add";
          gc     = "git commit";
          gp     = "git push";
          gs     = "git status";
          gd     = "git diff";
          gl     = "git log --oneline --graph";
          nrs    = "sudo nixos-rebuild switch --flake .";
          nrt    = "sudo nixos-rebuild test --flake .";
          nfu    = "nix flake update";
          nfc    = "nix flake check";
        };
      };

      programs.zoxide = {
        enable               = true;
        enableFishIntegration = true;
      };

      programs.eza = {
        enable               = true;
        enableFishIntegration = true;
        extraOptions         = [ "--group-directories-first" "--icons" "--git" ];
      };

      programs.bat = {
        enable = true;
      };

      programs.atuin = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          style = "compact";
          search_mode = "fuzzy";
        };
      };

      home.packages = with pkgs; [
        procs ripgrep fd fzf htop duf dust tldr
        jq yq curl wget zip unzip p7zip
        entr lazygit smassh pokemon-colorscripts
        cbonsai
      ];
    };
  };
}
