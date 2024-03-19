---@class plugins.nvim_dap.config

---@class plugins.nvim_dap.dap_config
---@field adapters? table[]
---@field configurations? table[]
---@field filetypes? string[]

---@class plugins.nvim_dap_virtual_text.config: nvim_dap_virtual_text_options

---@class plugins.mason_nvim_dap.config: MasonNvimDapSettings
---@field ensure_installed string[]
---@field handlers table<string, fun(config:plugins.nvim_dap.dap_config)>

---@type LazyPluginSpec[]
return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint condition",
      },
      -- stylua: ignore start
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
      -- stylua: ignore end
    },
    config = function(_, _)
      local icons = require("config").icons
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end
    end,
  },

  {
    "which-key.nvim",
    opts = {
      defaults = {
        ["<leader>d"] = { name = "+debug" },
      },
    },
  },

  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "nvim-dap" },
    keys = {
      -- stylua: ignore start
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
      -- stylua: ignore end
    },
    opts = {},
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "nvim-dap" },
    ---@type plugins.nvim_dap_virtual_text.config
    opts = {},
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = { "mason.nvim" },
    cmd = { "DapInstall", "DapUninstall" },
    ---@type plugins.mason_nvim_dap.config
    opts = {
      ensure_installed = {},
      handlers = {
        -- Default handler.
        function(config)
          require("mason-nvim-dap").default_setup(config)
        end,
      },
    },
  },
}
