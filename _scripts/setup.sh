#!/bin/bash
# ln -s ./raycast ~/.config/raycast

SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/../config.sh"

# 使用绝对路径确保路径正确
DOTFILES_DIR=$(realpath "$(dirname "$SCRIPT_DIR")")

# 函数：创建符号链接
create_symlink() {
    local src=$1
    local dst=$2

    # 替换 ~ 为 $HOME
    dst=${dst/#\~/$HOME}
    # echo -e "\nSymlink $src to $dst ..."

    # 检查源文件是否存在
    if [ ! -e "$src" ]; then
        echo -e "\n错误：源文件 $src 不存在。"
        return
    fi

    # 检查目标目录是否存在，不存在则创建
    local dst_dir=$(dirname "$dst")
    if [ ! -d "$dst_dir" ]; then
        echo "正在创建目录：$dst_dir"
        mkdir -p "$dst_dir"
        if [ $? -ne 0 ]; then
            echo "创建目录 $dst_dir 失败，请检查权限。"
            return
        fi
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then  # 检查文件存在或是符号链接
        echo -e "\n目标 $dst 已存在。"
        read -p "是否要覆盖？(y/N): " OVERRIDE

        if [[ ! $OVERRIDE =~ ^[Yy]$ ]]; then
            echo -e "已跳过。\n"
            return
        else
            # 如果用户选择覆盖，安全地删除
            if [ -L "$dst" ] || [ -f "$dst" ]; then
                rm "$dst"
            elif [ -d "$dst" ] && [ ! -L "$dst" ]; then
                echo "警告：$dst 是一个目录，不是符号链接。"
                read -p "您确定要删除这个目录吗？(y/N): " DELETE_DIR
                if [[ $DELETE_DIR =~ ^[Yy]$ ]]; then
                    rm -rf "$dst"
                else
                    echo -e "已跳过。\n"
                    return
                fi
            fi
        fi
    fi

    ln -s "$src" "$dst"
    # echo "ln -s $src $dst"

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
