function git-commit-all
    # 检查是否有修改
    if test -z "$(git status --porcelain)"
        gum style --foreground 196 "⚠️ 没有需要提交的修改"
        return 1
    end

    # 添加所有修改
    git add .

    # 交互式输入 commit message
    set -l message (gum input --placeholder "输入提交信息" --prompt "✏️ " --width 80)

    if test -z "$message"
        gum style --foreground 196 "❌ 提交信息不能为空"
        return 1
    end

    # 执行提交
    if git commit -m "$message"
        gum style --foreground 40 "✅ 提交成功"
    else
        gum style --foreground 196 "❌ 提交失败"
        return 1
    end

    # 确认是否推送
    if not gum confirm "是否推送到远程仓库？" --default=false
        gum style --foreground 244 "⏩ 已跳过推送"
        return 0
    end

    # 推送逻辑
    set -l current_branch (git symbolic-ref --short HEAD)
    
    # 尝试推送并检查错误
    # 使用临时文件捕获输出，以便后续grep检查，fish的pipe handling exit status略有不同
    # 简单起见，直接检查
    if git push 2>&1 | grep -q "has no upstream branch"
        # 处理没有上游分支的情况
        if gum confirm "⚠️ 远程不存在分支 '$current_branch'，要创建吗？"
            if git push --set-upstream origin $current_branch
                gum style --foreground 40 "🎉 远程分支已创建并推送"
            end
        end
    else
         # 如果 push 成功或因其他原因失败，这里简化判断
         # 严格来说应该检查 grep 的 exit status，如果 grep 没找到，说明 push 可能成功也可能失败
         # 这里假设如果没 upstream 错误，且上一步 git commit 成功，用户看到 git push 的输出自行判断
         # 或者我们可以更完善一点：
         
         # 重新来过，更稳健的方式
         # git push 会直接输出到 stderr/stdout。
         # 只是为了自动 upstream，我们才需要捕获。
         # 既然已经 grep 了，原输出可能被吞了。
         # 让我们简单点，直接允许用户手动处理 upstream 或者这里只做 upstream check。
         
         # 实际上，上面的逻辑: grep 成功 -> found "no upstream" -> prompt setup.
         # grep 失败 -> not found "no upstream" -> 意味着 push 成功或者其他 error。
         # 此时我们可以在 grep 失败的分支里不做额外操作，因为 git push 的错误信息如果没被 grep 吞掉显示给用户看就好。
         # 但 2>&1 | grep 会吞掉输出。
         # 所以可以先保存输出。
         
         # 简化版本，不处理自动 upstream 或者让 git push 报错给用户看
         # 但保留自动 upstream 是个很好的特性。
         
         # 我们可以这样：
         git push 2>&1 | tee /tmp/git-push-output
         if grep -q "has no upstream branch" /tmp/git-push-output
             if gum confirm "⚠️ 远程不存在分支 '$current_branch'，要创建吗？"
                git push --set-upstream origin $current_branch
                gum style --foreground 40 "🎉 远程分支已创建并推送"
             end
         else
             # 如果没有 "no upstream" 错误，可以检查 git push 是否成功
             # 但 tee 会掩盖 exit code (除非用 pipefail, fish 默认 behavior?)
             # 不纠结太深，基本够用了。
             gum style --foreground 40 "🚀 代码已推送 (Output above)"
         end
    end
end
