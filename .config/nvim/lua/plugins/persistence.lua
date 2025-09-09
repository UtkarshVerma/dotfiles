---@module "persistence"
---@class plugins.persistence.config: Persistence.Config

---@type LazyPluginSpec[]
return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    ---@type plugins.persistence.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      options = vim.split(vim.o.sessionoptions, ","),
    },
    -- stylua: ignore
    keys = {
      {
        "<leader>qs",
        function()
          require("persistence").load()

          -- Session restore seems to break filetype detection. So manually
          -- trigger BufRead after loading session.
          -- https://github.com/folke/persistence.nvim/issues/100
          vim.cmd("doautocmd BufRead")
        end,
        desc = "Restore session"
      },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
    },
  },
}
