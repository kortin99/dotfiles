return {
  -- 左侧的资源文件管理器
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- 文件系统
    filesystem = {
      filtered_items = {
        -- visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_gitignored = true,
        -- Shift + h to show hidden items
        hide_by_name = {
          "node_modules",
          ".git",
          -- '.DS_Store',
          -- 'thumbs.db',
        },
        never_show = {},
      },
      follow_current_file = true, -- 让 neo-tree 跟随当前文件
      use_libuv_file_watcher = true, -- 使用 libuv 更新文件更改
    },

    -- 图标
    renderer = {
      icons = {
        git = {
          unstaged = "🈳",
          untracked = "⏹️",
        },
      },
    },
  },
}
