---@module "blink.cmp"
---@class plugins.blink.config: blink.cmp.Config

---@type LazyPluginSpec[]
return {
  {
    "catppuccin",
    ---@type plugins.catppuccin.config
    opts = {
      integrations = {
        blink_cmp = true,
      },
    },
  },

  {
    "saghen/blink.cmp",
    event = "VeryLazy",
    version = "v0.*", -- Use a release tag to download pre-built binaries.
    opts_extend = { "sources.default" },

    ---@type plugins.blink.config
    opts = {
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
      },
      sources = {
        providers = {
          buffer = { min_keyword_length = 5 },
        },
        default = { "snippets", "lsp", "path", "buffer" },
      },
      signature = {
        enabled = true,
      },
      keymap = {
        preset = "none",
        ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<s-tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<cr>"] = { "accept", "fallback" },

        ["<c-e>"] = { "hide", "fallback" },
        ["<c-b>"] = { "scroll_documentation_up", "fallback" },
        ["<c-f>"] = { "scroll_documentation_down", "fallback" },
      },
    },
  },
}
