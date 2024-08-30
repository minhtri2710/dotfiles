set fish_greeting

set -gx TERM xterm-256color

# aliases
alias grep "grep -n --color "
alias fgrep "fgrep -n --color "
alias cls clear
alias g git
alias mux tmuxinator
alias :q exit
alias lg lazygit
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

#Thefuck
thefuck --alias fk | source

#Fzf
fzf --fish | source

# FZF Theme Customization
set fg "#CBE0F0"
set bg "#011628"
set bg_highlight "#143652"
set purple "#B388FF"
set blue "#06BCE4"
set cyan "#2CF9ED"

set -x FZF_DEFAULT_OPTS "--color=fg:$fg,bg:$bg,hl:$purple,fg+:$fg,bg+:$bg_highlight,hl+:$purple,info:$blue,prompt:$cyan,pointer:$cyan,marker:$cyan,spinner:$cyan,header:$cyan"

# Using fd Instead of fzf
set -x FZF_DEFAULT_COMMAND "fd --hidden --strip-cwd-prefix --exclude .git"
set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -x FZF_ALT_C_COMMAND "fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Custom Functions
function _fzf_compgen_path
    fd --hidden --exclude .git . $argv
end

function _fzf_compgen_dir
    fd --type=d --hidden --exclude .git . $argv
end

set show_file_or_dir_preview "if test -d {}; eza --tree --color=always {} | head -200; else; bat -n --color=always --line-range :500 {}; end"

set -x FZF_CTRL_T_OPTS "--preview '$show_file_or_dir_preview'"
set -x FZF_ALT_C_OPTS "--preview 'eza --tree --color=always {} | head -200'"

function _fzf_comprun
    switch $argv[1]
        case cd
            fzf --preview 'eza --tree --color=always {} | head -200' $argv[2..-1]
        case export, unset
            fzf --preview "eval 'echo {$argv[2]}'" $argv[3..-1]
        case ssh
            fzf --preview 'dig {}' $argv[2..-1]
        case '*'
            fzf --preview "$show_file_or_dir_preview" $argv[2..-1]
    end
end

# Bat (Better Cat)
set -x BAT_THEME tokyonight_night

thefuck --alias | source
