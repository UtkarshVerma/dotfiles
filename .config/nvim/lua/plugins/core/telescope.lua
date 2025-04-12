---@class util.telescope.picker.shared.layout_config
---@field anchor? ""|"CENTER"|"NW"|"N"|"NE"|"E"|"SE"|"S"|"SW"|"W"
---@field height? integer
---@field mirror? boolean
---@field prompt_position? "bottom"|"top"
---@field scroll_speed? integer
---@field width? number

---@class util.telescope.picker.horizontal.layout_config: util.telescope.picker.shared.layout_config
---@field preview_cutoff? integer
---@field preview_width? number

---@class util.telescope.layout_config
---@field horizontal? util.telescope.picker.horizontal.layout_config

---@class util.telescope.config.defaults
---@field prompt_prefix? string
---@field selection_caret? string
---@field entry_prefix? string
---@field border? boolean
---@field borderchars? table<"prompt"|"results"|"preview", util.ui.border.chars>
---@field get_status_text? fun(picker):string
---@field sorting_strategy? "ascending"|"descending"
---@field results_title? string
---@field layout_config? util.telescope.layout_config

---@class util.telescope.config
---@field defaults? util.telescope.config.defaults

local config = require("config")
local util = require("util")

---@type LazyPluginSpec[]
return {
  {
    "catppuccin",
    ---@type plugins.catppuccin.config
    opts = {
      integrations = {
        telescope = { enabled = true, style = "nvchad" },
      },
    },
  },

  {
    "nvim-telescope/telescope-fzf-native.nvim",
    dependencies = { "telescope.nvim" },
    build = "make",
    enabled = vim.fn.executable("make") == 1,
    config = function(_, _)
      util.plugin.on_load("telescope.nvim", function()
        require("telescope").load_extension("fzf")
      end)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "plenary.nvim" },
    ---@type util.telescope.config
    opts = {
      defaults = {
        prompt_prefix = " " .. config.icons.misc.Search .. " ",
        selection_caret = " ",
        entry_prefix = " ",
        sorting_strategy = "ascending",
        results_title = "",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
          width = 0.87,
          height = 0.8,
        },
      },
    },
  },
}
