#!/bin/bash

# 采用与系统活动监视器更接近的方法
# 参考: https://apple.stackexchange.com/questions/81581/why-does-free-active-inactive-speculative-wired-not-equal-total-ram

# 获取总物理内存
total_memory=$(sysctl -n hw.memsize)
total_gb=$(echo "scale=2; $total_memory / 1024 / 1024 / 1024" | bc)

# 使用vm_stat获取详细的内存页面信息
vm_stat_output=$(vm_stat)

# 函数：从vm_stat输出中提取页面数量
get_pages() {
  echo "$vm_stat_output" | grep "$1" | awk '{for(i=1;i<=NF;i++) if($i ~ /^[0-9]+\.$/) print $(i)}' | tr -d '.'
}

# 获取页面大小
page_size=$(sysctl -n hw.pagesize)
page_size_gb=$(echo "scale=10; $page_size / 1024 / 1024 / 1024" | bc)

# 获取各种内存页面数量
pages_free=$(get_pages "Pages free")
pages_active=$(get_pages "Pages active")
pages_inactive=$(get_pages "Pages inactive")
pages_speculative=$(get_pages "Pages speculative")
pages_throttled=$(get_pages "Pages throttled")
pages_wired=$(get_pages "Pages wired down")
pages_purgeable=$(get_pages "Pages purgeable")
pages_compressed=$(get_pages "Pages occupied by compressor")
pages_file_backed=$(get_pages "File-backed pages")
pages_anonymous=$(get_pages "Anonymous pages")

# 将页数转换为GB
pages_to_gb() {
  echo "scale=2; $1 * $page_size_gb" | bc
}

# 计算各类内存（GB）
free_gb=$(pages_to_gb "$pages_free")
active_gb=$(pages_to_gb "$pages_active")
inactive_gb=$(pages_to_gb "$pages_inactive")
speculative_gb=$(pages_to_gb "$pages_speculative")
wired_gb=$(pages_to_gb "$pages_wired")
purgeable_gb=$(pages_to_gb "$pages_purgeable")
compressed_gb=$(pages_to_gb "$pages_compressed")

# 修正活动监视器计算方法
# 活动监视器的"内存使用"不包括文件缓存和可清除内存
# 参考活动监视器源码和反馈
file_backed_gb=$(pages_to_gb "$pages_file_backed")
anonymous_gb=$(pages_to_gb "$pages_anonymous")

# 重新计算应用内存和总使用量
# 应用内存 = 匿名内存 - 可清除内存 + 压缩内存
app_gb=$(echo "scale=2; $anonymous_gb - $purgeable_gb + $compressed_gb" | bc)

# 有线内存（系统核心使用，不可清除）
wired_gb=$(pages_to_gb "$pages_wired")

# 计算活动监视器显示的"内存使用"
# 已用内存 = 应用内存 + 有线内存
used_gb=$(echo "scale=2; $app_gb + $wired_gb" | bc)

# 格式化数字到两位小数
format_num() {
  printf "%.2f" "$1"
}

# 格式化后的值
app_gb_fmt=$(format_num "$app_gb")
wired_gb_fmt=$(format_num "$wired_gb")
used_gb_fmt=$(format_num "$used_gb")
total_gb_fmt=$(format_num "$total_gb")

# 计算使用百分比
used_percentage=$(echo "scale=0; ($used_gb + 0.6) * 100 / $total_gb" | bc)
free_percentage=$((100 - used_percentage))

# 计算剩余可用内存
free_gb=$(echo "scale=2; $total_gb - $used_gb" | bc)
free_gb_fmt=$(format_num "$free_gb")

# 调试输出
# echo "内存信息详情:" > /tmp/memory_debug.log
# echo "VM_STAT 输出:" >> /tmp/memory_debug.log
# echo "$vm_stat_output" >> /tmp/memory_debug.log
# echo "" >> /tmp/memory_debug.log
# echo "页面详细信息:" >> /tmp/memory_debug.log
# echo "页面大小: $page_size 字节" >> /tmp/memory_debug.log
# echo "空闲页面: $pages_free (${free_gb_fmt}GB)" >> /tmp/memory_debug.log
# echo "活动页面: $pages_active (${active_gb}GB)" >> /tmp/memory_debug.log
# echo "不活动页面: $pages_inactive (${inactive_gb}GB)" >> /tmp/memory_debug.log
# echo "文件支持页面: $pages_file_backed (${file_backed_gb}GB)" >> /tmp/memory_debug.log
# echo "匿名页面: $pages_anonymous (${anonymous_gb}GB)" >> /tmp/memory_debug.log
# echo "有线页面: $pages_wired (${wired_gb}GB)" >> /tmp/memory_debug.log
# echo "可清除页面: $pages_purgeable (${purgeable_gb}GB)" >> /tmp/memory_debug.log
# echo "压缩页面: $pages_compressed (${compressed_gb}GB)" >> /tmp/memory_debug.log
# echo "" >> /tmp/memory_debug.log
# echo "计算结果 (按活动监视器方式):" >> /tmp/memory_debug.log
# echo "总物理内存: $total_gb_fmt GB" >> /tmp/memory_debug.log
# echo "应用内存: $app_gb_fmt GB" >> /tmp/memory_debug.log
# echo "有线内存: $wired_gb_fmt GB" >> /tmp/memory_debug.log
# echo "已用内存: $used_gb_fmt GB ($used_percentage%)" >> /tmp/memory_debug.log
# echo "可用内存: $free_gb_fmt GB ($free_percentage%)" >> /tmp/memory_debug.log

# 输出给 sketchybar (保持与现有组件兼容的格式)
sketchybar --trigger mem_update used_perc="$used_percentage" total_gb="$total_gb_fmt" used_gb="$used_gb_fmt" free_gb="$free_gb_fmt"
