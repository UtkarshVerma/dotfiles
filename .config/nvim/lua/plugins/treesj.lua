---@class plugins.treesj.config
---@field use_default_keymaps? boolean

---@type LazyPluginSpec[]
return {
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter" },
    -- stylua: ignore
    keys = {
      { "<leader>ct", function() require("treesj").toggle() end, desc = "Toggle split/join code block" },
      { "<leader>cj", function() require("treesj").join() end, desc = "Join code block" },
      { "<leader>cs", function() require("treesj").split() end, desc = "Split code block" },
    },
    ---@type plugins.treesj.config
    opts = {
      use_default_keymaps = false,
    },
  },
}
