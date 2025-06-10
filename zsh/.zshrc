# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

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

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM="$ZSH/custom"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
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

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=zh_CN.UTF-8

# 默认编辑器
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  # export EDITOR='nvim'
  # export EDITOR='trae'
  export EDITOR='cursor'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases

# quick config setup
alias zshconfig="${=EDITOR} ~/.zshrc"
alias zshrc="${=EDITOR} ~/.zshrc"
alias ohmyzsh="${=EDITOR} ~/.oh-my-zsh"
alias gitconfig="${=EDITOR} ~/.gitconfig"
alias yabaiconfig="${=EDITOR} ~/.config/yabai"
alias myip="ipconfig getifaddr en0"
alias python=python3

alias gti="git" # allow mistick type `git` as `gti`
alias lg="lazygit"
alias grep="grep --color=auto"
alias finder="open -a QSpace\ Pro"
alias json="jq"
alias p="ps -f"
alias cp="cp -i"
alias rm="rm -i"
alias mv="mv -i"
alias cd="z"
alias vim="nvim"
alias ls="eza --git --icons --color=always --group-directories-first"
alias tmux="tmux -f ~/.config/tmux/.tmux.conf"
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
alias pnpx="pnpm dlx"
alias cao="fuck"
alias "?"="tldr"
alias "@ai"="ask"
alias c="cursor"

# suffix aliases
alias -s zip="unzip"
alias -s gz="tar -zxvf"
alias -s tgz="tar -zxvf"
alias -s bz2="tar -jxvf"

#########################################################
########################  Git  #########################
########################################################

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

# 优雅的 commit all 工作流
git-commit-all() {
    # 检查是否有修改
    if [ -z "$(git status --porcelain)" ]; then
        gum style --foreground 196 "⚠️ 没有需要提交的修改"
        return 1
    fi

    # 添加所有修改
    git add .

    # 交互式输入 commit message
    local message=$(gum input --placeholder "输入提交信息" --prompt "✏️ " --width 80)

    if [ -z "$message" ]; then
        gum style --foreground 196 "❌ 提交信息不能为空"
        return 1
    fi

    # 执行提交
    if git commit -m "$message"; then
        gum style --foreground 40 "✅ 提交成功"
    else
        gum style --foreground 196 "❌ 提交失败"
        return 1
    fi

    # 推送逻辑
    local current_branch=$(git symbolic-ref --short HEAD)
    if ! git push 2>&1 | grep -q "has no upstream branch"; then
        gum style --foreground 40 "🚀 代码已推送"
        return 0
    fi

    # 处理没有上游分支的情况
    gum confirm "⚠️ 远程不存在分支 '$current_branch'，要创建吗？" && \
        git push --set-upstream origin $current_branch && \
        gum style --foreground 40 "🎉 远程分支已创建并推送"
}

git-branch-manager() {
  case $(gum choose "创建分支" "切换分支" "删除分支") in
    "创建分支")
      local new_branch=$(gum input --placeholder "新分支名...")
      [ -z "$new_branch" ] && return

      if git checkout -b "$new_branch" 2>&1 | gum spin --title "创建分支..."; then
        gum confirm "是否推送到远程仓库？" && git push --set-upstream origin "$new_branch"
      fi
      ;;

    "切换分支")
      git checkout $(git branch -a | gum filter --placeholder "选择分支..." | sed 's/^[* ]*//')
      ;;

    "删除分支")
      local branch=$(git branch | grep -v '\*' | gum filter --placeholder "选择删除对象")
      [ -z "$branch" ] && return

      gum confirm "确认删除分支 $branch？" && \
        git branch -D "$branch" | \
        gum spin --title "正在删除..."
      ;;
  esac
}

# 同步工作流（拉取并 rebase）
git-sync() {
    git fetch
    if ! git rebase origin/$(git symbolic-ref --short HEAD); then
        gum style --foreground 196 "❌ Rebase 冲突，请手动解决后执行 git rebase --continue"
        return 1
    fi
    gum style --foreground 40 "✅ 代码已同步"
}

git-merge() {
  local currentBranch=$(git rev-parse --abbrev-ref HEAD)
  local targetBranch=$1

  # 如果未提供目标分支，使用 gum 选择
  if [ -z "$targetBranch" ]; then
    # 检查是否安装了 gum
    if ! command -v gum &> /dev/null; then
      echo "请输入合并到哪个目标分支，例如: git-merge main"
      return 1
    fi
    targetBranch=$(git branch --list | cut -c 3- | gum filter --placeholder "请选择目标分支")
  fi

  # 检查目标分支是否存在
  if ! git rev-parse --verify "$targetBranch" &> /dev/null; then
    echo "错误：目标分支 '$targetBranch' 不存在。"
    return 1
  fi

  # 检查当前分支是否与目标分支相同
  if [ "$currentBranch" = "$targetBranch" ]; then
    echo "警告：当前分支已经是 '$targetBranch'，无需合并。"
    return 0
  fi

  # 确认合并操作
  if ! gum confirm "将当前分支 ($currentBranch) 的提交合并到分支 $targetBranch?"; then
    echo "合并操作已取消。"
    return 0
  fi

  # 进行合并操作
  git switch "$targetBranch" && \
  git pull -r origin "$targetBranch" && \
  git merge "$currentBranch" || return 1 # 如果失败则返回

  # 询问用户是否要推送更改
  if gum confirm "是否要将更改推送到 $targetBranch?"; then
    if ! gum spin --title "推送更改到 $targetBranch..." -- git push origin "$targetBranch"; then
      echo "错误：推送失败。"
      return 1
    fi
    if ! gum spin --title "切换回 $currentBranch..." -- git switch "$currentBranch"; then
      echo "警告：无法切换回当前分支 '$currentBranch'，请手动切换。"
      return 1
    fi
  fi
}
alias git-mr='git-merge'

# 使用命令行打开qspace (已加入进系统命令)
# qspace() {
#   open -a "QSpace Pro" $1
# }

# 使用命令行打开chrome链接
chrome() {
  open -a "Google Chrome" $1
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
export PNPM_HOME="/Users/kortin/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun completions
[ -s "/Users/kortin/.bun/_bun" ] && source "/Users/kortin/.bun/_bun"

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

export PATH=$PATH:/Users/kortin/.local/share/cargo/bin

# Android Studio
# /Users/kortin/Library/Android/sdk

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

# x-cmd

# bitwarden cli
export BW_SESSION="XUg4i0hlxunEVrd3Xq0nzbTmHfF2tznJebSIsf2RUkVgDTEfPJZPpKeSLiKlZlJp69A9XY9kDb2jHImuE5CO2w=="

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

# starship
# eval "$(starship init zsh)"




#########################################################
########################  环境  #########################
########################################################

# 使用系统代理
export https_proxy=http://127.0.0.1:17890 http_proxy=http://127.0.0.1:17890 all_proxy=socks5://127.0.0.1:17890
export no_proxy=192.168.0.0/16,10.0.0.0/8,172.16.0.0/12,127.0.0.1,localhost,.local,timestamp.apple.com,sequoia.apple.com,seed-sequoia.siri.apple.com,.ly.com,.elong.com,.17usoft.com,.17u.cn,.40017.cn,.tcent.cn,.hopegoo.com,.azgotrip.net,.elonghotel.com,.bigdata.com,.handhand.net,.tsinghua.edu.cn,23.94.56.114

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

compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

# zsh plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
source /opt/homebrew/share/fzf-tab/fzf-tab.plugin.zsh
