#!/bin/bash

# 确保脚本在当前目录下运行
CURR_DIR=$(dirname "$(realpath "$0")")
cd "$CURR_DIR" || exit

# 引入配置文件
source ./config.sh

# 处理子命令
case $1 in
    init)
        bash "$CURR_DIR/_scripts/init.sh"
        ;;
    setup)
        bash "$CURR_DIR/_scripts/setup.sh"
        ;;
    *)
        echo "Usage:"
        echo "  $ $0 {init|setup}"
        echo ""
        echo "Commands:"
        echo "  init     Copy the environment config files to current dotfiles project."
        echo "  setup    Apply current dotfiles to the environment."
        exit 1
        ;;
esac
