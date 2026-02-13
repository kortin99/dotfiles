# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="$HOME/.local/runtime/$UID"

# Path to your oh-my-zsh installation.
export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
export HISTFILE="$XDG_STATE_HOME/zsh/history"

SHELL_SESSIONS_DISABLE=1

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="wedisagree"

# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="yyyy-mm-dd"

ZSH_CUSTOM="$ZSH/custom"

plugins=(
  # git
  git-commit
  sudo
  command-not-found
  bun
  eza
  fzf
  rsync
  tldr # `Esc + tldr` to auto add tldr before the previous command
  # themes # `lstheme` or `theme [name]`
  # thefuck # twice Esc to correct previous command (conflicts with sudo plugin)
  # zsh-autosuggestions
  # zsh-syntax-highlighting
  zsh-interactive-cd
  # z
  zoxide
  # volta
  copypath
  copyfile
)

source $ZSH/oh-my-zsh.sh

compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

# zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/fzf-tab/fzf-tab.plugin.zsh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=zh_CN.UTF-8

if [ -f "$HOME/SECRET_KEYS.sh" ]; then
  source "$HOME/SECRET_KEYS.sh"
fi

# 默认编辑器
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  # export EDITOR='nvim'
  # export EDITOR='trae'
  export EDITOR='code'
fi

# quick config setup
alias lg="lazygit"
alias grep="grep --color=auto"
alias json="jq"
alias python=python3
alias ls="eza --git --icons --color=always --group-directories-first"
alias tmux="tmux -f $XDG_CONFIG_HOME/tmux/.tmux.conf"
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias cao="fuck"
alias "@ai"="ask"

# zsh-abbr
ABBR_SET_EXPANSION_CURSOR=1
ABBR_SET_LINE_CURSOR=1
ABBR_EXPANSION_CURSOR_MARKER=+
ABBR_QUIETER=1
ABBR_FORCE=1
source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh

abbr gti="git" # allow mistake type `git` as `gti`
abbr finder="open -a QSpace\ Pro"
abbr p="ps -f"
abbr cp="cp -i"
abbr rm="rm -i"
abbr mv="mv -i"
abbr vim="nvim"
abbr pnpx="pnpm dlx"
abbr "?"="tldr"
abbr cr="cursor"
abbr copy="pbcopy"
abbr cpy="pbcopy"
abbr zshconfig="${=EDITOR} ~/.zshrc"
abbr zshrc="${=EDITOR} ~/.zshrc"
abbr ohmyzsh="${=EDITOR} ~/.oh-my-zsh"
abbr gitconfig="${=EDITOR} ~/.gitconfig"
abbr yabaiconfig="${=EDITOR} ~/.config/yabai"
abbr myip="ipconfig getifaddr en0"
abbr "git cm"='git commit -m "%"'

# suffix aliases
alias -s zip="unzip"
alias -s gz="tar -zxvf"
alias -s tgz="tar -zxvf"
alias -s bz2="tar -jxvf"

# 使用命令行打开chrome链接
chrome() {
  open -a "Google Chrome" $1
}

# 重启服务
restart() {
  local app=$1

  if [ -z "$app" ]; then
    app=$(gum choose "zsh" "yabai" "sketchybar" "nginx")
  fi

  if [ -z "$app" ]; then
    echo "No service selected."
    return 1
  fi

  case "$app" in
    "zsh")
      echo "Sourcing ~/.zshrc..."
      source ~/.zshrc
      ;;
    "yabai")
      echo "Restarting yabai service..."
      yabai --restart-service
      ;;
    "sketchybar")
      echo "Reloading sketchybar configuration..."
      brew services restart sketchybar
      ;;
    "nginx")
      echo "Reloading Nginx server..."
      sudo systemctl reload nginx
      ;;
    *)
      echo "Unsupported argument. Usage: restart [yabai|zsh|nginx|sketchybar]"
      ;;
  esac
}

notify() {
  # 检查命令的退出状态
  if [ $? -eq 0 ]; then
    # 成功时发送通知
    osascript -e 'display notification "'"$1"'" with title "任务完成"'
  else
    # 失败时发送通知
   osascript -e 'display notification "'"$1"'" with title "任务失败"'
  fi
}






#########################################################
########################  前端  #########################
########################################################
# volta 配置
export VOLTA_HOME="$XDG_CONFIG_HOME/volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1

# npm XDG 目录配置
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/config/npm-init.js"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"

# node REPL 历史记录
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl_history"

# pnpm 环境变量
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm 配置
eval "$(fnm env --use-on-cd --shell zsh)"

# 删除volta指定node版本
rm-volta-node() {
  local nodeVersion=$1
  local nodePath="$XDG_CONFIG_HOME/volta/tools/image/node/$nodeVersion"
  if [ -d "$nodePath" ]; then
    rm -rf $nodePath
    echo "已删除volta node版本: $nodeVersion"
  else
    echo "volta node版本不存在: $nodeVersion"
  fi
}





#########################################################
########################  后端  #########################
########################################################
# XDG
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

# flutter
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
# export ANDROID_HOME=$HOME/WorkSpace/Env/Android
# export ANDROID_SDK_ROOT=$ANDROID_HOME/sdk
# export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
# export PATH=$PATH:$ANDROID_SDK_ROOT/tools

export PATH=$PATH:$HOME/.local/share/cargo/bin

# Android Studio
# $HOME/Library/Android/sdk

# python XDG
export PYTHON_HISTORY="$XDG_CACHE_HOME/python/history"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"


#########################################################
########################  工具  #########################
########################################################

# homebrew
export HOMEBREW_BOTTLE_DOMAIN=http://mirrors.aliyun.com/homebrew/homebrew-bottles
export HOMEBREW_NO_AUTO_UPDATE=1

# fzf
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

# tldr 命令行 cheatsheet 工具
export TLDR_LANGUAGE="zh"


# 使用 zoxide 替代 z
# eval "$(zoxide init zsh)"
eval $(thefuck --alias)

# iterm2
test -e "${HOME}/.config/iterm2/.iterm2_shell_integration.zsh" && source "${HOME}/.config/iterm2/.iterm2_shell_integration.zsh"

# wezterm
test -e "${HOME}/.config/wezterm/shell/shell_integration.sh" && source "${HOME}/.config/wezterm/shell/shell_integration.sh"
test -e "${HOME}/.config/wezterm/shell/shell_completion.zsh" && source "${HOME}/.config/wezterm/shell/shell_completion.zsh"

if [[ "$TERM_PROGRAM" == "WezTerm" ]]; then
  function update_wezterm_tab_title() {
    local dir_name
    if [[ "$PWD" == "$HOME" ]]; then
      dir_name="~"
    else
      dir_name=$(basename "$PWD")
    fi
    wezterm cli set-tab-title "$dir_name"
  }

  autoload -U add-zsh-hook
  add-zsh-hook chpwd update_wezterm_tab_title
  update_wezterm_tab_title
fi

# starship
# eval "$(starship init zsh)"




#########################################################
########################  环境  #########################
########################################################

bundle-id() {
    local app_name="$1"
    osascript -e "id of app \"$app_name\""
}

# 使用系统代理
set-proxy() {
    # export https_proxy=http://127.0.0.1:17890 http_proxy=http://127.0.0.1:17890 all_proxy=socks5://127.0.0.1:17890
    export http_proxy=http://agent.baidu.com:8891 https_proxy=http://agent.baidu.com:8891
    export no_proxy=192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,127.0.0.1,localhost,.local,timestamp.apple.com,sequoia.apple.com,seed-sequoia.siri.apple.com,.ly.com,.elong.com,.17usoft.com,.17u.cn,.40017.cn,.tcent.cn,.hopegoo.com,.azgotrip.net,.elonghotel.com,.bigdata.com,.handhand.net,.tsinghua.edu.cn,baidu-int.com,baidu.com
}

unset-proxy() {
  unset http_proxy
  unset https_proxy
  unset all_proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
  unset ALL_PROXY
}

# 设置终端默认输入法为英文
eval $(im-select com.apple.keylayout.ABC)

source "$XDG_CONFIG_HOME/zsh/git.zsh"
