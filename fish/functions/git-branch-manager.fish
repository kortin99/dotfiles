function git-branch-manager
  set -l choice (gum choose "创建分支" "切换分支" "删除分支")
  
  switch "$choice"
    case "创建分支"
      set -l new_branch (gum input --placeholder "新分支名...")
      if test -z "$new_branch"; return; end

      if git checkout -b "$new_branch" 2>&1 | gum spin --title "创建分支..."
        if gum confirm "是否推送到远程仓库？"
             git push --set-upstream origin "$new_branch"
        end
      end

    case "切换分支"
      set -l branch (git branch -a | gum filter --placeholder "选择分支..." | sed 's/^[* ]*//' | string trim)
      if test -n "$branch"
          git checkout $branch
      end

    case "删除分支"
      set -l branch (git branch | grep -v '\*' | gum filter --placeholder "选择删除对象" | string trim)
      if test -z "$branch"; return; end

      if gum confirm "确认删除分支 $branch？"
        git branch -D "$branch" | gum spin --title "正在删除..."
      end
  end
end
