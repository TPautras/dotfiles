{ self, inputs, ... }: {
  flake.homeManagerModules.starship = { config, lib, ... }:
  with lib; let
    cfg = config.hm.starship;
    ef  = self.lib.palette;
  in {
    options.hm.starship.enable = mkEnableOption "Starship prompt Everforest";

    config = mkIf cfg.enable {
      programs.starship = {
        enable               = true;
        enableFishIntegration = true;
        settings = {
          format = concatStrings [
            "$directory"
            "$git_branch"
            "$git_status"
            "$python"
            "$lua"
            "$c"
            "$nix_shell"
            "$cmd_duration"
            "$line_break"
            "$character"
          ];

          palette = "everforest";
          palettes.everforest = {
            inherit (ef) green aqua blue purple yellow orange red gray fg bg2;
          };

          character = {
            success_symbol = "[❯](bold green)";
            error_symbol   = "[❯](bold red)";
          };
          directory = {
            style            = "bold aqua";
            truncation_length = 3;
            truncate_to_repo  = true;
            read_only         = " 󰌾";
          };
          git_branch = {
            symbol = " ";
            style  = "bold purple";
          };
          git_status = {
            style    = "bold red";
            ahead    = "⇡$count";
            behind   = "⇣$count";
            diverged = "⇕⇡$ahead_count⇣$behind_count";
            modified = "!$count";
            untracked = "?$count";
            staged   = "+$count";
          };
          nix_shell = {
            symbol = " ";
            style  = "bold blue";
            format = "[$symbol$state( \\($name\\))]($style) ";
          };
          python = {
            symbol = " ";
            style  = "bold yellow";
          };
          lua = {
            symbol = " ";
            style  = "bold blue";
          };
          c = {
            symbol = " ";
            style  = "bold blue";
          };
          cmd_duration = {
            min_time = 2000;
            style    = "bold yellow";
            format   = "[ $duration]($style) ";
          };
        };
      };
    };
  };
}
