#!/bin/bash
# ln -s ./raycast ~/.config/raycast

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/../config.sh"

DOTFILES_DIR=$(pwd)

# 函数：创建符号链接
create_symlink() {
    local src=$1
    local dst=$2

    # 替换 ~ 为 $HOME
    dst=${dst/#\~/$HOME}
    # echo -e "\nSymlink $src to $dst ..."

    if [ -e "$dst" ]; then
        echo -e "\nDestination $dst already exists."
        read -p "Do you want to overwrite it? (y/N): " OVERRIDE

        if [[ ! $OVERRIDE =~ ^[Yy]$ ]]; then
            echo -e "Skipped.\n"
            return
        else
            # 如果用户选择覆盖，则删除旧的链接或目录
            rm -rf "$dst"
        fi
    fi

    ln -s "$src" "$dst"
    echo "ln -s $src $dst"
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
