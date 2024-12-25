---@module "smart-splits"
---@class plugins.smart_splits.config: SmartSplitsConfig

---@type LazyPluginSpec[]
return {
  {
    "mrjones2014/smart-splits.nvim",
    keys = {
      -- stylua: ignore start
      { "<c-left>", function() require("smart-splits").resize_left() end, desc = "Resize left" },
      { "<c-down>", function() require("smart-splits").resize_down() end, desc = "Resize down" },
      { "<c-up>", function() require("smart-splits").resize_up() end, desc = "Resize up" },
      { "<c-right>", function() require("smart-splits").resize_right() end, desc = "Resize right" },

      { "<c-w>h", function() require("smart-splits").move_cursor_left() end, desc = "Move to left split" },
      { "<c-w>j", function() require("smart-splits").move_cursor_down() end, desc = "Move to below split" },
      { "<c-w>k", function() require("smart-splits").move_cursor_up() end, desc = "Move to above split" },
      { "<c-w>l", function() require("smart-splits").move_cursor_right() end, desc = "Move to right split" },
      { "<c-w>w", function() require("smart-splits").move_cursor_previous() end, desc = "Move to previous split" },

      { "<c-w><s-h>", function() require("smart-splits").swap_buf_left() end, desc = "Swap with left buffer" },
      { "<c-w><s-j>", function() require("smart-splits").swap_buf_down() end, desc = "Swap with below buffer" },
      { "<c-w><s-k>", function() require("smart-splits").swap_buf_up() end, desc = "Swap with above buffer" },
      { "<c-w><s-l>", function() require("smart-splits").swap_buf_right() end, desc = "Swap with right buffer" },
      -- stylua: ignore end
    },
    ---@type plugins.smart_splits.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {},
  },
}
