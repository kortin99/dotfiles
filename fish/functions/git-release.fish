function git-release
  set -l currentBranch (git branch --show-current)
  set -l targetBranch $argv[1]

  if test -z "$targetBranch"
      echo "Usage: git-release <target-branch>"
      return 1
  end

  git switch $targetBranch
  echo "正在拉取远程分支: $targetBranch"
  git pull origin $targetBranch
  echo "合并($currentBranch)到分支: $targetBranch"
  git merge $currentBranch
  git push origin $targetBranch
  git switch $currentBranch
  echo "已从当前分支($currentBranch)合并并推送到远程分支: $targetBranch"
end
