function git-sync
    git fetch
    set -l current_branch (git symbolic-ref --short HEAD)
    if not git rebase origin/$current_branch
        gum style --foreground 196 "❌ Rebase 冲突，请手动解决后执行 git rebase --continue"
        return 1
    end
    gum style --foreground 40 "✅ 代码已同步"
end
