{ self, inputs, ... }: {
  flake.homeManagerModules.tmux = { config, pkgs, lib, ... }:
  with lib; let
    cfg = config.hm.tmux;
    ef  = self.lib.palette;
  in {
    options.hm.tmux.enable = mkEnableOption "tmux Everforest + config vi";

    config = mkIf cfg.enable {
      programs.tmux = {
        enable       = true;
        clock24      = true;
        historyLimit = 100000;
        keyMode      = "vi";
        prefix       = "C-a";
        terminal     = "tmux-256color";
        baseIndex    = 1;
        mouse        = true;
        escapeTime   = 0;

        plugins = with pkgs.tmuxPlugins; [
          sensible
          vim-tmux-navigator
          yank
          resurrect
          {
            plugin = continuum;
            extraConfig = "set -g @continuum-restore 'on'";
          }
        ];

        extraConfig = ''
          set -ga terminal-overrides ",*256col*:Tc"
          set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
          set-environment -g COLORTERM "truecolor"

          set-window-option -g pane-base-index 1
          set-option -g renumber-windows on

          EF_BG="${ef.bg}"
          EF_BG2="${ef.bg2}"
          EF_FG="${ef.fg}"
          EF_GREEN="${ef.green}"
          EF_AQUA="${ef.aqua}"
          EF_YELLOW="${ef.yellow}"
          EF_GRAY="${ef.gray}"

          set -g status-style                "bg=$EF_BG,fg=$EF_FG"
          set -g status-left-length          40
          set -g status-right-length         80
          set -g status-left                 "#[bg=$EF_GREEN,fg=$EF_BG,bold] #S #[bg=$EF_BG,fg=$EF_GREEN]"
          set -g status-right                "#[fg=$EF_GRAY] %H:%M  %d %b #[bg=$EF_GREEN,fg=$EF_BG,bold] #h "
          set -g window-status-format        " #I:#W "
          set -g window-status-current-format "#[bg=$EF_BG2,fg=$EF_AQUA,bold] #I:#W "
          set -g pane-border-style           "fg=$EF_BG2"
          set -g pane-active-border-style    "fg=$EF_GREEN"
          set -g message-style               "bg=$EF_BG2,fg=$EF_YELLOW"

          bind | split-window -h -c "#{pane_current_path}"
          bind - split-window -v -c "#{pane_current_path}"
          unbind '"'
          unbind %

          bind h select-pane -L
          bind j select-pane -D
          bind k select-pane -U
          bind l select-pane -R

          bind -r H resize-pane -L 5
          bind -r J resize-pane -D 5
          bind -r K resize-pane -U 5
          bind -r L resize-pane -R 5

          bind-key -T copy-mode-vi v   send-keys -X begin-selection
          bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
          bind-key -T copy-mode-vi y   send-keys -X copy-selection-and-cancel

          bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

          bind c new-window -c "#{pane_current_path}"
        '';
      };
    };
  };
}
