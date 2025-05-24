return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      tsserver = {
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = "$VOLTA_HOME/tools/image/packages/@vue/language-server",
              languages = { "vue" },
            },
          },
        },
      },
      volar = {
        init_options = {
          vue = {
            hybridMode = false,
          },
        },
      },
    },
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      -- change a keymap
      keys[#keys + 1] = { "<C-i", "K" }
      -- disable a keymap
      keys[#keys + 1] = { "K", false }
      -- add a keymap
      -- keys[#keys + 1] = { "H", "<cmd>echo 'hello'<cr>" }
    end,
  },
}
