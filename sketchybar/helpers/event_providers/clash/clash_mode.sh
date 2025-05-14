# curl -s GET http://127.0.0.1:9097/configs | jq .mode

# 获取 clash 当前模式
clash_mode=$(curl -s GET http://127.0.0.1:9097/configs | jq .mode)

# 打印当前模式
sketchybar --trigger clash_mode_update clash_mode="$clash_mode"
