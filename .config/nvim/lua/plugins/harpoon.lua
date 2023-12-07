local util = require("util")

return {
  {
    "ThePrimeagen/harpoon",
    dependencies = {
      "plenary.nvim",
      {
        "which-key.nvim",
        opts = {
          defaults = {
            ["<leader>h"] = { name = "+harpoon" },
          },
        },
      },
    },
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
    opts = {
      settings = {
        save_on_toggle = false,
        border_chars = util.ui.generate_borderchars("thick"),
        key = util.root.get,
      },
    },
    config = function(_, opts)
      require("harpoon"):setup(opts)
    end,
  },

  {
    "vim-illuminate",
    opts = function(_, opts)
      opts.filetypes_denylist = vim.list_extend(opts.filetypes_denylist or {}, {
        "harpoon",
      })
    end,
  },
}
