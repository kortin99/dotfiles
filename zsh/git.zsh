
#########################################################
########################  Git  #########################
########################################################

# git-release <remote-branch> : 将当前分支的提交强制推送到远程分支，以触发CI/CD
git-release() {
  local currentBranch=$(git branch --show-current)
  # git pull -r origin ${1}
  git switch ${1}
  echo "正在拉取远程分支: ${1}"
  git pull origin ${1}
  echo "合并($currentBranch)到分支: ${1}"
  git merge $currentBranch
  git push origin ${1}
  git switch $currentBranch
  echo "已从当前分支($currentBranch)合并并推送到远程分支: ${1}"
}

alias git-rls='git-release'

# git-merge <target-branch> : 合并当前分支到指定分支
# git-merge() {
#   local currentBranch=$(git rev-parse --abbrev-ref HEAD)
#   local targetBranch=$1
#   echo "将当前分支($currentBranch)的提交合并到分支${targetBranch}"
#   if [ -z "$targetBranch" ]; then
#     targetBranch = git branch --list | gum filter
#   fi
#   git switch $targetBranch
#   git pull origin $targetBranch
#   git merge $currentBranch
#   git switch $currentBranch
# }

# 优雅的 commit all 工作流
git-commit-all() {
    # 检查是否有修改
    if [ -z "$(git status --porcelain)" ]; then
        gum style --foreground 196 "⚠️ 没有需要提交的修改"
        return 1
    fi

    # 添加所有修改
    git add .

    # 交互式输入 commit message
    local message=$(gum input --placeholder "输入提交信息" --prompt "✏️ " --width 80)

    if [ -z "$message" ]; then
        gum style --foreground 196 "❌ 提交信息不能为空"
        return 1
    fi

    # 执行提交
    if git commit -m "$message"; then
        gum style --foreground 40 "✅ 提交成功"
    else
        gum style --foreground 196 "❌ 提交失败"
        return 1
    fi

    # 确认是否推送
    if ! gum confirm "是否推送到远程仓库？" --default=false; then
        gum style --foreground 244 "⏩ 已跳过推送"
        return 0
    fi

    # 推送逻辑
    local current_branch=$(git symbolic-ref --short HEAD)
    if ! git push 2>&1 | grep -q "has no upstream branch"; then
        gum style --foreground 40 "🚀 代码已推送"
        return 0
    fi

    # 处理没有上游分支的情况
    gum confirm "⚠️ 远程不存在分支 '$current_branch'，要创建吗？" && \
        git push --set-upstream origin $current_branch && \
        gum style --foreground 40 "🎉 远程分支已创建并推送"
}

git-branch-manager() {
  case $(gum choose "创建分支" "切换分支" "删除分支") in
    "创建分支")
      local new_branch=$(gum input --placeholder "新分支名...")
      [ -z "$new_branch" ] && return

      if git checkout -b "$new_branch" 2>&1 | gum spin --title "创建分支..."; then
        gum confirm "是否推送到远程仓库？" && git push --set-upstream origin "$new_branch"
      fi
      ;;

    "切换分支")
      git checkout $(git branch -a | gum filter --placeholder "选择分支..." | sed 's/^[* ]*//')
      ;;

    "删除分支")
      local branch=$(git branch | grep -v '\*' | gum filter --placeholder "选择删除对象")
      [ -z "$branch" ] && return

      gum confirm "确认删除分支 $branch？" && \
        git branch -D "$branch" | \
        gum spin --title "正在删除..."
      ;;
  esac
}

# 同步工作流（拉取并 rebase）
git-sync() {
    git fetch
    if ! git rebase origin/$(git symbolic-ref --short HEAD); then
        gum style --foreground 196 "❌ Rebase 冲突，请手动解决后执行 git rebase --continue"
        return 1
    fi
    gum style --foreground 40 "✅ 代码已同步"
}

git-merge() {
  local currentBranch=$(git rev-parse --abbrev-ref HEAD)
  local targetBranch=$1

  # 如果未提供目标分支，使用 gum 选择
  if [ -z "$targetBranch" ]; then
    # 检查是否安装了 gum
    if ! command -v gum &> /dev/null; then
      echo "请输入合并到哪个目标分支，例如: git-merge main"
      return 1
    fi
    targetBranch=$(git branch --list | cut -c 3- | gum filter --placeholder "请选择目标分支")
  fi

  # 检查目标分支是否存在
  if ! git rev-parse --verify "$targetBranch" &> /dev/null; then
    echo "错误：目标分支 '$targetBranch' 不存在。"
    return 1
  fi

  # 检查当前分支是否与目标分支相同
  if [ "$currentBranch" = "$targetBranch" ]; then
    echo "警告：当前分支已经是 '$targetBranch'，无需合并。"
    return 0
  fi

  # 确认合并操作
  if ! gum confirm "将当前分支 ($currentBranch) 的提交合并到分支 $targetBranch?"; then
    echo "合并操作已取消。"
    return 0
  fi

  # 进行合并操作
  git switch "$targetBranch" && \
  git pull -r origin "$targetBranch" && \
  git merge "$currentBranch" || return 1 # 如果失败则返回

  # 询问用户是否要推送更改
  if gum confirm "是否要将更改推送到 $targetBranch?"; then
    if ! gum spin --title "推送更改到 $targetBranch..." -- git push origin "$targetBranch"; then
      echo "错误：推送失败。"
      return 1
    fi
    if ! gum spin --title "切换回 $currentBranch..." -- git switch "$currentBranch"; then
      echo "警告：无法切换回当前分支 '$currentBranch'，请手动切换。"
      return 1
    fi
  fi
}
alias git-mr='git-merge'
