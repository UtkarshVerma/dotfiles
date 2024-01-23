local util = require("util")

---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      defaults = {
        ["<leader>h"] = { name = "+harpoon" },
      },
    },
  },

  {
    "ThePrimeagen/harpoon",
    dependencies = { "plenary.nvim" },
    branch = "harpoon2",
    keys = {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():append()
        end,
        desc = "Append to list",
      },
      {
        "<leader>hh",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Toggle quick menu",
      },
    },
    ---@type HarpoonConfig
    ---@diagnostic disable: missing-fields
    opts = {
      settings = {
        save_on_toggle = false,
        border_chars = util.ui.borderchars("thick"),
        key = util.root.dir,
      },
    },
    ---@diagnostic enable: missing-fields
    config = function(_, opts)
      require("harpoon"):setup(opts)
    end,
  },
}
