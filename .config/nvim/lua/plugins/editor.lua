return {
  {
    "NMAC427/guess-indent.nvim",
    event = { "BufReadPre" },
    config = true,
  },
  { "RRethy/vim-illuminate", enabled = false },
  {
    "max397574/better-escape.nvim",
    event = { "BufReadPre" },
    opts = {
      mapping = { "jk", "jj", "kj" },
    },
    config = function(_, opts)
      require("better_escape").setup(opts)
    end,
  },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      require("which-key").register({
        ["<leader>d"] = {
          name = "+debug",
        },
      })
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
    "echasnovski/mini.comment",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        options = {
          ignore_blank_line = true,
        },
      })
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
