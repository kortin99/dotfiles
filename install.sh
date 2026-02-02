#!/bin/bash

# 确保脚本在当前目录下运行
CURR_DIR=$(dirname "$(realpath "$0")")
cd "$CURR_DIR" || exit

# 引入配置文件
source ./config.sh

# 处理子命令
case $1 in
    backup)
        bash "$CURR_DIR/_scripts/backup.sh"
        ;;
    setup)
        bash "$CURR_DIR/_scripts/setup.sh" "${@:2}"
        ;;
    *)
        echo "Usage:"
        echo "  $ $0 {backup|setup}"
        echo ""
        echo "Commands:"
        echo "  backup      Copy the environment config files to current dotfiles project."
        echo "  setup       Apply current dotfiles to the environment."
        echo "    --skip    Apply current dotfiles to the environment, skip overwriting existing files."
        exit 1
        ;;
esac
