#!/bin/sh

# 获取所有 vscode 窗口的 id
vscode_ids=$(yabai -m query --windows | jq '.[] | select(.app == "Code") | .id')

# 如果找到 vscode 窗口
if [ -n "$vscode_ids" ]; then

	# 循环遍历所有 vscode 窗口的 id
	for window_id in $vscode_ids; do
		# 使用 yabai 命令将当前窗口堆叠到目标窗口上
		yabai -m window --focus --stack "$window_id"
	done
fi
