fish_add_path -g "$HOME/.local/bin"
fish_add_path -g "$HOME/.cargo/bin"

set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive
    type -q pokemon-colorscripts; and pokemon-colorscripts --no-title -r

    abbr -a -- ..  'cd ..'
    abbr -a -- ... 'cd ../..'
    abbr -a ls  'eza --icons --group-directories-first'
    abbr -a ll  'eza -la --icons --group-directories-first --git'
    abbr -a la  'eza -a --icons'
    abbr -a lt  'eza --tree --icons --level=2'
    abbr -a cat bat
    abbr -a grep rg
    abbr -a ps  procs
    abbr -a top htop
    abbr -a df  duf
    abbr -a du  dust
    abbr -a mkdir 'mkdir -p'

    abbr -a g  git
    abbr -a ga 'git add'
    abbr -a gc 'git commit'
    abbr -a gp 'git push'
    abbr -a gs 'git status'
    abbr -a gd 'git diff'
    abbr -a gl 'git log --oneline --graph'

    abbr -a d   docker
    abbr -a dc  'docker compose'
    abbr -a dps 'docker ps'
    abbr -a dl  'docker logs -f'

    type -q starship; and starship init fish | source
    type -q zoxide;   and zoxide init fish | source
    type -q atuin;    and atuin init fish | source
end
