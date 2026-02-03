set -g fish_greeting ""

# PATH Configuration
fish_add_path "$HOME/.local/bin"

# XDG Base Directory
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_RUNTIME_DIR "$HOME/.local/runtime/"(id -u)

# Default Editor
if test -n "$SSH_CONNECTION"
    set -gx EDITOR 'vim'
else
    set -gx EDITOR 'code'
end

# Language
set -gx LANG zh_CN.UTF-8

# Volta
set -gx VOLTA_HOME "$XDG_CONFIG_HOME/volta"
fish_add_path "$VOLTA_HOME/bin"
set -gx VOLTA_FEATURE_PNPM 1

# NPM XDG
set -gx NPM_CONFIG_USERCONFIG "$XDG_CONFIG_HOME/npm/npmrc"
set -gx NPM_CONFIG_INIT_MODULE "$XDG_CONFIG_HOME/npm/config/npm-init.js"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -gx NPM_CONFIG_TMP "$XDG_RUNTIME_DIR/npm"

# Node REPL
set -gx NODE_REPL_HISTORY "$XDG_STATE_HOME/node_repl_history"

# PNPM
set -gx PNPM_HOME "$HOME/Library/pnpm"
fish_add_path "$PNPM_HOME"

# BUN
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"

# Rust / Cargo
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"
fish_add_path "$HOME/.local/share/cargo/bin"

# Docker
set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"

# Flutter
set -gx PUB_HOSTED_URL https://pub.flutter-io.cn
set -gx FLUTTER_STORAGE_BASE_URL https://storage.flutter-io.cn

# Python
set -gx PYTHON_HISTORY "$XDG_CACHE_HOME/python/history"
set -gx PYTHONSTARTUP "$XDG_CONFIG_HOME/python/pythonrc"

# Homebrew
set -gx HOMEBREW_BOTTLE_DOMAIN http://mirrors.aliyun.com/homebrew/homebrew-bottles
set -gx HOMEBREW_NO_AUTO_UPDATE 1

# TLDR
set -gx TLDR_LANGUAGE "zh"

# Aliases
alias lg "lazygit"
alias grep "grep --color=auto"
alias json "jq"
alias python "python3"
alias ls "eza --git --icons --color=always --group-directories-first"
alias tmux "tmux -f $XDG_CONFIG_HOME/tmux/.tmux.conf"
alias wget "wget --hsts-file=$XDG_DATA_HOME/wget-hsts"
alias cao "fuck"
alias "@ai" "ask"
alias git-rls "git-release"
alias git-mr "git-merge"

# Abbrs
if status is-interactive
    abbr -a gti git
    abbr -a finder "open -a QSpace\ Pro"
    abbr -a p "ps -f"
    abbr -a cp "cp -i"
    abbr -a rm "rm -i"
    abbr -a mv "mv -i"
    abbr -a vim "nvim"
    abbr -a pnpx "pnpm dlx"
    abbr -a "?" "tldr"
    abbr -a cr "cursor"
    abbr -a copy "pbcopy"
    abbr -a cpy "pbcopy"
    abbr -a fishconfig "$EDITOR ~/.config/fish/config.fish"
    abbr -a zshconfig "$EDITOR ~/.zshrc"
    abbr -a gitconfig "$EDITOR ~/.gitconfig"
    abbr -a yabaiconfig "$EDITOR ~/.config/yabai"
    abbr -a myip "ipconfig getifaddr en0"
    abbr -a gcm --set-cursor 'git commit -m "%"'
end

# Tools Initialization
if type -q fnm
    fnm env --use-on-cd --shell fish | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q thefuck
    thefuck --alias | source
end

# Starship (uncomment if installed)
if type -q starship
    starship init fish | source
end

# iTerm2 Integration
if test -e "$HOME/.iterm2_shell_integration.fish"
    source "$HOME/.iterm2_shell_integration.fish"
end

# WezTerm Integration
# WezTerm usually injects itself, or check for specific fish integration if needed.

# im-select
if type -q im-select
    im-select com.apple.keylayout.ABC
end

# Load custom keys if exists
if test -f "$HOME/SECRET_KEYS.sh"
    source "$HOME/.SECRET_KEYS.sh"
end
