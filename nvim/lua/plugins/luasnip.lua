return {
  "L3MON4D3/LuaSnip",
  config = function()
    -- 自动加载 VSCode 风格的代码片段
    require("luasnip.loaders.from_vscode").lazy_load()

    -- 更多的 `LuaSnip` 配置可以放在这里
  end,
}
