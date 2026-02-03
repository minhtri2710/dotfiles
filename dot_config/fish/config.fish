set fish_greeting

# PATH Configuration
fish_add_path bin
fish_add_path ~/bin
fish_add_path ~/.local/bin
fish_add_path ~/.nix-profile/bin
fish_add_path ~/.cargo/bin
fish_add_path /opt/local/bin
fish_add_path ~/go/bin
fish_add_path ~/.bun/bin

set -gx COLORTERM truecolor

# aliases
alias bd br
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

set -gx EDITOR nvim

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

#NVM
set -gx nvm_default_version latest

#Antigravity
fish_add_path /Users/beowulf/.antigravity/antigravity/bin

#direnv
direnv hook fish | source

function oc
    set base_name (basename (pwd))
    set path_hash (echo (pwd) | md5 | cut -c1-4)
    set session_name "$base_name-$path_hash"

    # Find available port starting from 4096
    function __oc_find_port
        set port 4096
        while test $port -lt 5096
            if not lsof -i :$port >/dev/null 2>&1
                echo $port
                return 0
            end
            set port (math $port + 1)
        end
        echo 4096
    end

    set oc_port (__oc_find_port)
    set -x OPENCODE_PORT $oc_port

    if set -q TMUX
        # Already inside tmux - just run with port
        opencode --port $oc_port $argv
    else
        # Create tmux session and run opencode
        set oc_cmd "OPENCODE_PORT=$oc_port opencode --port $oc_port $argv; exec fish"
        if tmux has-session -t "$session_name" 2>/dev/null
            tmux new-window -t "$session_name" -c (pwd) "$oc_cmd"
            tmux attach-session -t "$session_name"
        else
            tmux new-session -s "$session_name" -c (pwd) "$oc_cmd"
        end
    end

    functions -e __oc_find_port
end
