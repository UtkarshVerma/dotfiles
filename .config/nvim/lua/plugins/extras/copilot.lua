return {
  {
    "zbirenbaum/copilot.lua",
    main = "copilot",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { auto_trigger = true },
      panel = { enabled = false },
    },
  },
  {
    -- TODO: Make this component floating as well
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      local util = require("util")
      local colors = {
        [""] = util.ui.get_hl("Special"),
        ["Normal"] = util.ui.get_hl("Special"),
        ["Warning"] = util.ui.get_hl("DiagnosticError"),
        ["InProgress"] = util.ui.get_hl("DiagnosticWarn"),
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
