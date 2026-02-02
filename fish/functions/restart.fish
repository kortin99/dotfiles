function restart
  set -l app $argv[1]

  if test -z "$app"
    set app (gum choose "fish" "yabai" "sketchybar" "nginx")
  end

  if test -z "$app"
    echo "No service selected."
    return 1
  end

  switch "$app"
    case "fish"
      echo "Sourcing ~/.config/fish/config.fish..."
      source ~/.config/fish/config.fish
    case "yabai"
      echo "Restarting yabai service..."
      yabai --restart-service
    case "sketchybar"
      echo "Reloading sketchybar configuration..."
      brew services restart sketchybar
    case "nginx"
      echo "Reloading Nginx server..."
      sudo systemctl reload nginx
    case "*"
      echo "Unsupported argument. Usage: restart [yabai|fish|nginx|sketchybar]"
  end
end
