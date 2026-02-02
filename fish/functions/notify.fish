function notify
  set -l last_status $status
  # 检查命令的退出状态
  if test $last_status -eq 0
    # 成功时发送通知
    osascript -e 'display notification "'"$argv[1]"'" with title "任务完成"'
  else
    # 失败时发送通知
   osascript -e 'display notification "'"$argv[1]"'" with title "任务失败"'
  end
end
