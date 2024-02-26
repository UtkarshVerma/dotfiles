---@class plugins.scrollview.config
---@field current_only? boolean
---@field signs_on_startup? string[]
---@field excluded_filetypes? string[]

---@type LazyPluginSpec[]
return {
  {
    "dstein64/nvim-scrollview",
    event = "LazyFile",
    ---@type plugins.scrollview.config
    opts = {
      current_only = true,
      signs_on_startup = {},
      excluded_filetypes = {
        "prompt",
        "lazy",
        "noice",
        "DressingInput",
        "cmp_docs",
        "dashboard",
        "neo-tree",
        "mason",
        "TelescopePrompt",
        "",
      },
    },
  },
}
