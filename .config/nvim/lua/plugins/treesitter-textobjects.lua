---@class plugins.treesitter_textobjects.config.move
---@field enable? boolean
---@field goto_next_start? table<string, string>
---@field goto_next_end? table<string, string>
---@field goto_previous_start? table<string, string>
---@field goto_previous_end? table<string, string>

---@class plugins.treesitter_textobjects.config
---@field move? plugins.treesitter_textobjects.config.move

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    opts = {
      ---@type plugins.treesitter_textobjects.config
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter" },

    -- NOTE: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/513
    commit = "73e44f43c70289c70195b5e7bc6a077ceffddda4",
  },
}
