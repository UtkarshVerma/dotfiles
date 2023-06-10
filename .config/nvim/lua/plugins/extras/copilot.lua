return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { auto_trigger = true },
      panel = { enabled = false },
    },
    config = function(_, opts)
      require("copilot").setup(opts)
    end,
  },
  {
    -- TODO: Make this component floating as well
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local util = require("util")
      local colors = {
        [""] = util.get_highlight_value("Special"),
        ["Normal"] = util.get_highlight_value("Special"),
        ["Warning"] = util.get_highlight_value("DiagnosticError"),
        ["InProgress"] = util.get_highlight_value("DiagnosticWarn"),
      }
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local icon = require("config").icons.kinds.Copilot
          local status = require("copilot.api").status.data
          return icon .. (status.message or "")
        end,
        cond = function()
          local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
          return ok and #clients > 0
        end,
        color = function()
          if not package.loaded["copilot"] then
            return
          end
          local status = require("copilot.api").status.data
          return colors[status.status] or colors[""]
        end,
      })
    end,
  },
}
