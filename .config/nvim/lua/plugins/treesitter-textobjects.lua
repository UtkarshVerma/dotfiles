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
    dependencies = { "nvim-treesitter-textobjects" },
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
    event = "VeryLazy",
    -- NOTE: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/513
    commit = "73e44f43c70289c70195b5e7bc6a077ceffddda4",
    opts = {},
    config = function(_, _)
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },
}
