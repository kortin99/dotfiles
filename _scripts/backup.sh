#!/bin/bash

# 引入配置文件
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/../config.sh"

# 使用绝对路径确保路径正确
DOTFILES_DIR=$(realpath "$(dirname "$SCRIPT_DIR")")

# 循环处理每个配置项
for link in "${CONFIGS[@]}"; do
    # 分割配置项为源路径和目标路径
    IFS=' ' read -r -a parts <<< "$link"
    src="${parts[1]}"
    dst="${DOTFILES_DIR}/${parts[0]}"

    # 确保 ~ 被正确展开，使用更安全的方式
    src="${src/#\~/$HOME}"

    # 使用 realpath 确保路径被正确解析
    if [ ! -e "$src" ]; then
        echo "警告：源路径 $src 不存在，已跳过。"
        continue
    fi

    resolved_src=$(realpath "$src")
    echo "正在复制 $resolved_src --> $dst"

    # 检查目标文件或目录是否已经存在
    if [ -e "$dst" ]; then
        echo -e "\n目标 $dst 已存在。"
        read -p "是否要覆盖？(y/N): " response
        case "$response" in
            [Yy]* )
                # 安全地删除目标
                if [ -L "$dst" ] || [ -f "$dst" ]; then
                    rm "$dst"
                elif [ -d "$dst" ] && [ ! -L "$dst" ]; then
                    echo "警告：$dst 是一个目录，不是链接文件。"
                    read -p "您确定要删除这个目录吗？(y/N): " DELETE_DIR
                    if [[ $DELETE_DIR =~ ^[Yy]$ ]]; then
                        rm -rf "$dst"
                    else
                        echo "跳过 $dst"
                        continue
                    fi
                fi
                ;;
            * )
                echo "跳过 $dst"
                continue
                ;;
        esac
    fi

    # 确保目标父目录存在
    dst_dir=$(dirname "$dst")
    if [ ! -d "$dst_dir" ]; then
        echo "正在创建目录：$dst_dir"
        mkdir -p "$dst_dir"
        if [ $? -ne 0 ]; then
            echo "创建目录 $dst_dir 失败，请检查权限。"
            continue
        fi
    fi

    # 执行复制操作
    cp -rpf "$resolved_src" "$dst"
    if [ $? -ne 0 ]; then
        echo "复制 $resolved_src 到 $dst 失败，请检查权限。"
    fi
done

echo -e "\n所有文件和目录已处理完成。"
