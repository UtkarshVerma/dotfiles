local Util = require("lazyvim.util")

return {
  {
    "NMAC427/guess-indent.nvim",
    event = "BufReadPost",
    config = true,
  },
  { "RRethy/vim-illuminate", enabled = false },
  {
    "folke/which-key.nvim",
    opts = {
      plugins = {
        spelling = { enabled = true },
        presets = {
          windows = false, -- disable as it interferes with <c-w> mapping
        },
      },
    },
  },
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
      { "<c-w>", "<leader>bd", desc = "Delete Buffer", remap = true },
    },
  },
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_list = {
        {
          auto_export = 0,
          path_html = "~/notes/output/",
          path = "~/notes/vimwiki/",
          syntax = "default",
          ext = ".wiki",
        },
        {
          path = "~/notes/gsi/",
          syntax = "markdown",
          ext = ".md",
        },
      }
    end,
    cmd = "VimwikiIndex",
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        mappings = {
          i = {
            ["<c-t>"] = function(...)
              return require("trouble.providers.telescope").open_with_trouble(...)
            end,
            ["<c-i>"] = function()
              Util.telescope("find_files", { no_ignore = true })()
            end,
            ["<c-h>"] = function()
              Util.telescope("find_files", { hidden = true })()
            end,
            ["<c-down>"] = function(...)
              return require("telescope.actions").cycle_history_next(...)
            end,
            ["<c-up>"] = function(...)
              return require("telescope.actions").cycle_history_prev(...)
            end,
            ["<esc>"] = require("telescope.actions").close,
          },
        },
      },
    },
  },
}
