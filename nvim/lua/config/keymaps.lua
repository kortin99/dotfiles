-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are  lways set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local del = vim.keymap.del

local opts = { silent = true, noremap = true }

map("i", "jk", "<Esc>", opts)
map("n", "<C-i>", vim.lsp.buf.hover, opts)

-- 忽略折叠的代码块
-- map("n", "j", "gj", opts)
-- map("n", "k", "gk", opts)

-- 快速上下移动
map("n", "J", "10j", opts)
map("n", "K", "10k", opts)

-- 快速移动到行首和行尾
map("n", "H", "^", opts)
map("n", "L", "g_", opts)

-- 快速操作到行首和行尾
map("n", "dL", "d$", opts)
map("n", "dH", "d^", opts)
map("n", "cL", "c$", opts)
map("n", "cH", "c^", opts)
map("v", "L", "g_", opts)
map("v", "H", "^", opts)

-- 保存文件
-- map("n", "<leader>s", "<cmd>w<CR>", opts)

-- 复制到系统剪切板
map("v", "Y", '"+y', { noremap = true, desc = "Copy to system clipboard" })
map("n", "Y", '"+yy', { noremap = true, desc = "Copy to system clipboard" })

-- map("n", "U", "<C-r>")
map("n", "<Esc>", ":nohlsearch<CR>", opts)

-- 重新加载配置
map("n", "<leader>R", "<cmd>source ~/.config/nvim/init.lua<CR>", { desc = "Reload nvim config" })

map("t", "<D-[>", "<Esc>", opts)
map("t", "<M-a>", "gg<S-v>G", opts)
