-- bootstrap lazy.nvim, LazyVim and your plugins

if vim.g.vscode then
  -- VSCode extension
  local vscode = require("vscode-neovim")
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      -- vscode.notify("回到了 Normal 模式")
      os.execute("im-select com.apple.keylayout.ABC")
    end,
  })
  vim.cmd("autocmd VimEnter * startinsert")
  require("config.lazy")
else
  -- ordinary Neovim
  require("config.lazy")
end
