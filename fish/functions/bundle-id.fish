function bundle-id
    set -l app_name "$argv[1]"
    osascript -e "id of app \"$app_name\""
end
