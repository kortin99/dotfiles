function git-merge
  set -l currentBranch (git rev-parse --abbrev-ref HEAD)
  set -l targetBranch $argv[1]

  # 如果未提供目标分支，使用 gum 选择
  if test -z "$targetBranch"
    # 检查是否安装了 gum
    if not type -q gum
      echo "请输入合并到哪个目标分支，例如: git-merge main"
      return 1
    end
    set targetBranch (git branch --list | cut -c 3- | gum filter --placeholder "请选择目标分支" | string trim)
  end

  if test -z "$targetBranch"; return 1; end

  # 检查目标分支是否存在
  if not git rev-parse --verify "$targetBranch" &> /dev/null
    echo "错误：目标分支 '$targetBranch' 不存在。"
    return 1
  end

  # 检查当前分支是否与目标分支相同
  if test "$currentBranch" = "$targetBranch"
    echo "警告：当前分支已经是 '$targetBranch'，无需合并。"
    return 0
  end

  # 确认合并操作
  if not gum confirm "将当前分支 ($currentBranch) 的提交合并到分支 $targetBranch?"
    echo "合并操作已取消。"
    return 0
  end

  # 进行合并操作
  if git switch "$targetBranch"; and git pull -r origin "$targetBranch"; and git merge "$currentBranch"
      # Success logic continues below
  else
      return 1
  end

  # 询问用户是否要推送更改
  if gum confirm "是否要将更改推送到 $targetBranch?"
    if not gum spin --title "推送更改到 $targetBranch..." -- git push origin "$targetBranch"
      echo "错误：推送失败。"
      return 1
    end
    if not gum spin --title "切换回 $currentBranch..." -- git switch "$currentBranch"
      echo "警告：无法切换回当前分支 '$currentBranch'，请手动切换。"
      return 1
    end
  end
end
