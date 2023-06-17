return {
  {
    "vimwiki/vimwiki",
    cmd = "VimwikiIndex",
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
  },
  {
    "nvim-neorg/neorg",
    cmd = "Neorg",
    build = ":Neorg sync-parsers",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      load = {
        ["core.defaults"] = {}, -- Loads default behaviour
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.dirman"] = {
          config = {
            workspaces = {
              gsoc = "~/notes/gsoc",
            },
          },
        },
      },
    },
  },
}
