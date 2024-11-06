#!/bin/bash

# ln -s ~/.config/raycast ./raycast

# LINKS=(
#     "raycast            ~/.config/raycast"
#     "nvim               ~/.config/nvim"
#     "yabai              ~/.config/yabai"
#     "yabai              ~/.config/yabai"
#     "wezterm            ~/.config/wezterm"
#     "iterm2             ~/.config/iterm2"
#     "sketchybar         ~/.config/sketchybar"
#     "tmux               ~/.config/tmux"
#     "lazygit            ~/.config/lazygit"
#     "zsh/.zshrc         ~/.zshrc    "
#     "git/.gitconfig     ~/.gitconfig"
#     "hammerspoon        ~/.hammerspoon"
# )
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/../config.sh"

DOTFILES_DIR=$(pwd)

# 函数：创建符号链接
create_symlink() {
    local src=$1
    local dst=$2

    # 替换 ~ 为 $HOME
    dst=${dst/#\~/$HOME}
    echo "Soft link $src to $dst ..."

    if [ -e "$dst" ]; then
        echo "检测到已存在的 $dst 配置文件。"
        read -p "您想要覆盖现有的配置文件吗？(y/N): " OVERRIDE

        if [[ ! $OVERRIDE =~ ^[Yy]$ ]]; then
            # echo "取消操作。"
            return
        else
            # 如果用户选择覆盖，则删除旧的链接或目录
            if [ -L "$dst" ]; then
                # rm "$dst"
                echo "[]rm"
            elif [ -d "$dst" ] || [ -f "$dst" ]; then
                # rm -rf "$dst"
                echo "[]rm -rf"
            fi
        fi
    fi

    # ln -s "$src" "$dst"
    # echo "[] 建立连接"

    # if [ $? -eq 0 ]; then
    #     echo "成功创建了从 $src 到 $dst 的符号链接。"
    # else
    #     echo "创建符号链接失败，请检查路径或权限。"
    # fi
    if [ $? -ne 0 ]; then
      echo "创建符号链接失败，请检查路径或权限。"
    fi
}

# 主循环，处理每个链接
for link in "${CONFIGS[@]}"; do
    # 使用 IFS 选项来处理多个空格
    IFS=' ' read -r -a parts <<< "$link"
    src="${parts[0]}"
    dst="${parts[1]}"
    create_symlink "$DOTFILES_DIR/$src" "$dst"
done
