return {
  {
    "dstein64/nvim-scrollview",
    event = "LazyFile",
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
