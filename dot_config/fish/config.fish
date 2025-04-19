set fish_greeting
set -gx TERM xterm-ghostty

# aliases
alias grep "grep -n --color "
alias fgrep "fgrep -n --color "
alias cls clear
alias g git
alias mux tmuxinator
alias :q exit
alias lg lazygit
alias v nvim
alias vi nvim
alias vim nvim
alias ls "eza --color=always -l --icons=always"
alias la "ls -a"
alias ll "ls -g"
alias l1 "ls -g -1 "
alias lla "ll -a"

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH node_modules/.bin $PATH

set fzf_preview_dir_cmd lla

#Starship
starship init fish | source

#Zoxide
zoxide init --cmd cd fish | source

# Bat (Better Cat)
set -x BAT_THEME tokyonight_night

#Set Env
set -x XDG_CONFIG_HOME ~/.config

#Set Yazi
function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

#Fzf
fzf --fish | source

set show_file_or_dir_preview "if test -d {}; eza --tree --color=always {} | head -200; else; bat -n --color=always --line-range :500 {}; end"

set -x FZF_CTRL_T_OPTS "--preview '$show_file_or_dir_preview'"
set -x FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -199'"
