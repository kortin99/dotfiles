function rm-volta-node
  set -l nodeVersion $argv[1]
  # Using $XDG_CONFIG_HOME if set, otherwise default?
  # In config.fish we set XDG_CONFIG_HOME. But inside function, it relies on env var.
  # Assuming XDG_CONFIG_HOME is set in config.fish and exported.
  
  if test -z "$XDG_CONFIG_HOME"
      set XDG_CONFIG_HOME "$HOME/.config"
  end

  set -l nodePath "$XDG_CONFIG_HOME/volta/tools/image/node/$nodeVersion"
  if test -d "$nodePath"
    rm -rf $nodePath
    echo "已删除volta node版本: $nodeVersion"
  else
    echo "volta node版本不存在: $nodeVersion"
  fi
end
