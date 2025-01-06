# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Path to your oh-my-zsh installation.
export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="wedisagree"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
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
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="$ZSH/custom"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  # z
  sudo
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

# bitwarden cli
export BW_SESSION="XUg4i0hlxunEVrd3Xq0nzbTmHfF2tznJebSIsf2RUkVgDTEfPJZPpKeSLiKlZlJp69A9XY9kDb2jHImuE5CO2w=="

# quick config setup
alias zshconfig="code ~/.zshrc"
alias ohmyzsh="code ~/.oh-my-zsh"
alias gitconfig="code ~/.gitconfig"
alias yabaiconfig="code ~/.config/yabai"
alias myip="ipconfig getifaddr en0"
alias python=python3

# always mistick type `git` as `gti`
alias gti="git"
alias lg="lazygit"
alias grep="grep --color=auto"
alias finder="open -a QSpace\ Pro"
alias json="jq"
alias cd="z"
alias ls="eza --git --icons --color=always --group-directories-first"
alias tmux="tmux -f ~/.config/tmux/.tmux.conf"
alias pnpx="pnpm dlx"
alias "?"="tldr"

# suffix aliases
alias -s zip="unzip"
alias -s gz="tar -zxvf"
alias -s tgz="tar -zxvf"
alias -s bz2="tar -jxvf"

#
# Git shortcuts
#

# git-release <remote-branch> : 将当前分支的提交强制推送到远程分支，以触发CI/CD
git-release() {
  local currentBranch=$(git branch --show-current)
  # git pull -r origin ${1}
  git switch ${1}
  echo "正在拉取远程分支: ${1}"
  git pull origin ${1}
  echo "合并($currentBranch)到分支: ${1}"
  git merge $currentBranch
  git push origin ${1}
  git switch $currentBranch
  echo "已从当前分支($currentBranch)合并并推送到远程分支: ${1}"
}

alias git-rls='git-release'

# git-merge <target-branch> : 合并当前分支到指定分支
# git-merge() {
#   local currentBranch=$(git rev-parse --abbrev-ref HEAD)
#   local targetBranch=$1
#   echo "将当前分支($currentBranch)的提交合并到分支${targetBranch}"
#   if [ -z "$targetBranch" ]; then
#     targetBranch = git branch --list | gum filter
#   fi
#   git switch $targetBranch
#   git pull origin $targetBranch
#   git merge $currentBranch
#   git switch $currentBranch
# }

git-merge() {
  local currentBranch=$(git rev-parse --abbrev-ref HEAD)
  local targetBranch=$1

  if [ -z "$targetBranch" ]; then
    # 检查是否安装了 gum
    if ! command -v gum &> /dev/null; then
      echo "请输入合并到哪个目标分支，例如: git-merge main"
      return 1
    fi
    targetBranch=$(git branch --list | cut -c 3- | gum filter)
  fi

  # 检查用户是否选择了目标分支
  if [ -z "$targetBranch" ]; then
    echo "未选择目标分支。"
    return 1
  fi

  echo "将当前分支 ($currentBranch) 的提交合并到分支 $targetBranch"

  # 进行合并操作
  git switch "$targetBranch" && \
  git pull origin "$targetBranch" && \
  git merge "$currentBranch" && \
  git switch "$currentBranch" || return 1 # 如果失败则返回

  # 可选：询问用户是否要推送更改
  read -p "是否要将更改推送到 $targetBranch? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    git switch "$targetBranch" && \
    git push origin "$targetBranch" && \
    git switch "$currentBranch"
  fi
}


alias git-mr='git-merge'

# 发布预发环境
release-stage(){
  local currentBranch=$(git symbolic-ref --short -q HEAD)
  git branch -D ${1}
  git switch -c ${1}
  git push -f origin ${1}
  git switch $currentBranch
  echo "已从当前分支($currentBranch)强制推送到远程分支: ${1}"
}

# 使用命令行打开qspace (已加入进系统命令)
# qspace() {
#   open -a "QSpace Pro" $1
# }

# 使用命令行打开chrome链接
chrome() {
  open -a "Google Chrome" $1
}

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

# 重启服务
restart() {
  case "$1" in
    "yabai")
      echo "Restarting yabai service..."
      yabai --restart-service
      ;;
    "sketchybar")
      echo "Reloading sketchytbar configration..."
      brew services restart sketchybar
      ;;
    "zsh")
      echo "Sourcing ~/.zshrc..."
      source ~/.zshrc
      ;;
    "nginx")
      echo "Reloading Nginx server..."
      sudo systemctl reload nginx
      ;;
    *)
      echo "Unsupported argument. Usage: restart [yabai|zsh|nginx]"
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


#
# Env Exports
#
export LANG="zh_CN.UTF-8"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

test -e "${HOME}/.config/wezterm/shell_integration.zsh" && source "${HOME}/.config/wezterm/shell_integration.zsh"

export HOMEBREW_BOTTLE_DOMAIN=http://mirrors.aliyun.com/homebrew/homebrew-bottles
export HOMEBREW_NO_AUTO_UPDATE=1
# export PATH="$PATH:/usr/local/opt/python/libexec/bin"

# flutter
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
# export ANDROID_HOME=$HOME/WorkSpace/Env/Android
# export ANDROID_SDK_ROOT=$ANDROID_HOME/sdk
# export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin
# export PATH=$PATH:$ANDROID_SDK_ROOT/tools

# Android Studio
# /Users/kortin/Library/Android/sdk

# bun
export BUN_INSTALL="$XDG_CONFIG_HOME/bun"
export PATH="$BUN_INSTALL/bin:$PATH"
# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
# bun end

# npm
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
# npm end

# pnpm
export PNPM_HOME="/Users/kortin/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# tldr 命令行 cheatsheet 工具
export TLDR_LANGUAGE="zh"

# volta
export VOLTA_HOME="$XDG_CONFIG_HOME/volta"
export PATH="$VOLTA_HOME/bin:$PATH"
export VOLTA_FEATURE_PNPM=1
# volta end

# 使用 zoxide 替代 z
eval "$(zoxide init zsh)"

# 使用系统代理
# export https_proxy=http://127.0.0.1:17890 http_proxy=http://127.0.0.1:17890 all_proxy=socks5://127.0.0.1:17890
export no_proxy=192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,127.0.0.1,localhost,.local,timestamp.apple.com,sequoia.apple.com,seed-sequoia.siri.apple.com,.ly.com,.elong.com,.17usoft.com,.17u.cn,.40017.cn,.tcent.cn,.hopegoo.com,.azgotrip.net,.elonghotel.com,.bigdata.com,.handhand.net,.tsinghua.edu.cn,23.94.56.114

alias '?'=tldr

export PATH="$HOME/.local/bin:$PATH"
