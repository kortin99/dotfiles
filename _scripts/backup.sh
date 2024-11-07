#!/bin/bash

# 引入配置文件
SCRIPT_DIR=$(dirname "$(realpath "$0")")
source "$SCRIPT_DIR/../config.sh"
# echo "$SCRIPT_DIR"
# echo "$SCRIPT_DIR/../config.sh"

# 循环处理每个配置项
for link in "${CONFIGS[@]}"; do
    # 分割配置项为源路径和目标路径
    IFS=' ' read -r -a parts <<< "$link"
    src="${parts[1]}"
    dst="./${parts[0]}"

    # 确保 ~ 被正确展开
    src=$(eval echo $src)

    # 使用 realpath 确保路径被正确解析
    resolved_src=$(realpath "$src" 2>/dev/null)
    if [ -z "$resolved_src" ]; then
        echo "Warning: Source path $src does not exist, skipping."
        continue
    fi
    # 输出调试信息
    # echo "Processing: $link"
    # echo "Source: $resolved_src"
    # echo "Destination: $dst"
    echo "Copying $resolved_src --> $dst"

    # 检查源路径是否存在
    if [ ! -e "$resolved_src" ]; then
        echo "Warning: Resolved source path $resolved_src does not exist, skipping."
        continue
    fi

    # 检查目标文件或目录是否已经存在
    if [ -e "$dst" ]; then
        echo -e "\nDestination $dst already exists."
        read -p "Do you want to overwrite it? (y/N): " response
        case "$response" in
            [Yy]* )
                rm -rf "$dst"
                ;;
            * )
                echo "Skipping $dst"
                continue
                ;;
        esac
    fi

    if [ ! -e "$(dirname "$dst")" ]; then
        # 复制前先创建目录
        mkdir -p "$(dirname "$dst")"
    fi

    # 执行 cp -rpi 命令
    # echo "Copying $resolved_src to $dst"
    cp -rpf "$resolved_src" "$dst"
done

echo -e "\nAll files and directories have been processed."
