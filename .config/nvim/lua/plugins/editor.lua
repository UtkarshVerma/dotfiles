return {
  {
    "NMAC427/guess-indent.nvim",
    event = { "BufReadPre" },
    config = true,
  },
  { "RRethy/vim-illuminate", enabled = false },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        plugins = {
          presets = {
            windows = false, -- disable as it interferes with <c-w> mapping
          },
        },
      })
    end,
  },
  {
    "echasnovski/mini.bufremove",
    keys = function(_, keys)
      return vim.list_extend({
        { "<c-w>", "<leader>bd", desc = "Delete Buffer", remap = true },
      }, keys)
    end,
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
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        defaults = {
          mappings = {
            i = { ["<esc>"] = require("telescope.actions").close },
          },
        },
      })
    end,
  },
}
