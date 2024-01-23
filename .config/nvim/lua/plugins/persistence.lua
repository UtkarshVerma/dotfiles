---@class plugins.persistence.config
---@field options string[]

---@type LazyPluginSpec[]
return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    ---@type plugins.persistence.config
    opts = {
      options = {
        "buffers",
        "curdir",
        "tabpages",
        "winsize",
        "help",
        "globals",
        "skiprtp",
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
    },
  },
}
