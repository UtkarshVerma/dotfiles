---@class plugins.nvim_dap.adapter: Adapter
---@class plugins.nvim_dap.configuration: Configuration
---@class plugins.nvim_dap.session: Session

---@class plugins.nvim_dap.config
---@field adapters? table<string, plugins.nvim_dap.adapter|fun(callback:fun(adapter:plugins.nvim_dap.adapter), config?:plugins.nvim_dap.configuration, parent?:plugins.nvim_dap.session)>
---@field configurations? table<string, plugins.nvim_dap.configuration[]>

---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    opts = {
      spec = {
        { "<leader>d", group = "debug" },
      },
    },
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "nvim-dap",
      "nvim-treesitter",
    },
    opts = {},
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      -- stylua: ignore start
      { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = { "n", "v" } },
      -- stylua: ignore end
    },
    opts = {},
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-dap-ui",
      "nvim-dap-virtual-text",
    },
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
    ---@type plugins.nvim_dap.config
    opts = {
      adapters = {},
      configurations = {},
    },
    ---@param opts plugins.nvim_dap.config
    config = function(_, opts)
      local icons = require("config").icons
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, config in pairs(icons.dap) do
        config = type(config) == "table" and config or { config }

        local text = config[1]
        local text_hl = config[2] or "DiagnosticInfo"
        local num_hl = config[3]
        vim.fn.sign_define("Dap" .. name, { text = text, texthl = text_hl, linehl = num_hl, numhl = num_hl })
      end

      local dap = require("dap")
      dap.adapters = vim.tbl_extend("force", dap.adapters, opts.adapters)
      dap.configurations = vim.tbl_extend("force", dap.configurations, opts.configurations)

      -- Load VS Code launch configurations.
      if vim.fn.filereadable(".vscode/launch.json") then
        require("dap.ext.vscode").load_launchjs(nil, { ["platformio-debug"] = { "c", "cpp", "asm" } })
      end

      local dapui = require("dapui")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
