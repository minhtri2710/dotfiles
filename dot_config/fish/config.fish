set fish_greeting
if test -n "$TMUX"
    set -gx TERM tmux-256color
else if test "$TERM_PROGRAM" = ghostty
    set -gx TERM xterm-ghostty
else
    set -gx TERM xterm-256color
end

set -gx COLORTERM truecolor

# aliases
alias cls clear
alias g git
alias mux tmuxinator
alias :q exit
alias lg lazygit
alias ld lazydocker
alias v nvim
alias vi nvim
alias vim nvim
alias ls "eza --color=always -l --icons=always"
alias la "ls -a"
alias ll "ls -g"
alias l1 "ls -g -1 "
alias lla "ll -a"
alias rm trash
alias oc opencode

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH
set -gx PATH ~/.nix-profile/bin $PATH
set -gx PATH ~/.cargo/bin $PATH
set -gx PATH /opt/local/bin $PATH

set fzf_preview_dir_cmd lla

#Starship
source (starship init fish --print-full-init | psub)

#Zoxide
zoxide init --cmd cd fish | source

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

set -x SNACKS_GHOSTTY true

#Atuin
atuin init fish | source

#Rust
set -gx RUSTUP_TOOLCHAIN nightly

#OpenCode
set -gx OPENCODE_DISABLE_AUTOCOMPACT 1 # Disable broken compaction
set -gx OPENCODE_DISABLE_PRUNE 1 # Disable potentially buggy pruning
set -gx OPENCODE_EXPERIMENTAL 1 # Enable experimental features

#Private
source ~/.config/fish/private.fish

#ProxyPal
# source ~/.config/fish/proxypal.fish

#NVM
set -gx nvm_default_version latest

#Antigravity
fish_add_path /Users/beowulf/.antigravity/antigravity/bin

#direnv
direnv hook fish | source
