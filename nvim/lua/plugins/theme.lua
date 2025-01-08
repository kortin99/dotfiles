return {
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    opts = {
      groups = {},
    },
  },

  -- add gruvbox
  -- { "ellisonleao/gruvbox.nvim" },
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = true,
  --   opts = { style = "moon" },
  -- },

  -- {
  --   "navarasu/onedark.nvim",
  --   lazy = true,
  --   opts = { style = "darker", transparent = true },
  -- },

  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   opts = {
  --     transparent = true,
  --   },

  -- {
  --   "folke/tokyonight.nvim",
  --   -- lazy = false,
  --   name = "tokyonight",
  --   opts = {
  --     style = "dark",
  --     transparent = true,
  --     styles = {
  --       sidebars = "transparent",
  --       floats = "transparent",
  --     },
  --   },
  -- },

  -- {
  --   "uloco/bluloco.nvim",
  --   lazy = false,
  --   dependencies = { "rktjmp/lush.nvim" },
  --   opts = {
  --     style = "dark",
  --     transparent = true,
  --     italics = false,
  --     terminal = vim.fn.has("gui_running") == 1,
  --     guicursor = true,
  --   },
  -- },

  {
    "ribru17/bamboo.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("bamboo").setup({
        -- optional configuration here
        style = "multiplex",
        transparent = true,
      })
      require("bamboo").load()
    end,
  },

  -- Configure LazyVim to load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "bamboo",
    },
  },
}
