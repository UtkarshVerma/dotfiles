local adapters = {
  bashdb = {
    type = "executable",
    command = "bash-debug-adapter",
    name = "bashdb",
  },
  cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = "OpenDebugAD7",
  },
}

local configurations = {
  c = {
    {
      name = "Launch file",
      type = "cppdbg",
      request = "launch",
      program = function()
        ---@diagnostic disable-next-line: redundant-parameter
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = true,
    },
    {
      name = "Attach to gdbserver :1234",
      type = "cppdbg",
      request = "launch",
      MIMode = "gdb",
      miDebuggerServerAddress = "localhost:1234",
      miDebuggerPath = "/usr/bin/gdb",
      cwd = "${workspaceFolder}",
      program = function()
        ---@diagnostic disable-next-line: redundant-parameter
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
    },
  },
  sh = {
    {
      type = "bashdb",
      request = "launch",
      name = "Launch file",
      showDebugOutput = true,
      pathBashdb = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
      pathBashdbLib = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
      trace = true,
      file = "${file}",
      program = "${file}",
      cwd = "${workspaceFolder}",
      pathCat = "cat",
      pathBash = "/bin/bash",
      pathMkfifo = "mkfifo",
      pathPkill = "pkill",
      args = {},
      env = {},
      terminalKind = "integrated",
    },
  },
}

configurations.cpp = configurations.c
-- -- nvim-telescope/telescope-dap.nvim
-- require("telescope").load_extension("dap")({ "<leader>ds", ":Telescope dap frames<CR>" }),

-- stylua: ignore
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
      "mfussenegger/nvim-dap-python",
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    keys = {
      {
        "<leader>d?",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "DAP Inspect"
      },
      { "<leader>dk", ':lua require"dap".up()<CR>zz' },
      { "<leader>dj", ':lua require"dap".down()<CR>zz' },
      -- { "<leader>dr", ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l' },
      { "<leader>du", ':lua require"dapui".toggle()<CR>' },
      { "<leader>dc", ":Telescope dap commands<CR>" },
      { "<leader>dl", ":Telescope dap list_breakpoints<CR>" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dB",function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Set Breakpoint Condition" },
      { "<leader>dn", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      -- { "<leader>dc", function() require("dap").terminate() end },
      { "<leader>dc", function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" },
      { "<leader>de", function() require("dap").set_exception_breakpoints({ "all" }) end, desc = "Set Exception Breakpoints" },
      { "<leader>di", function() require("dap.ui.widgets").hover() end },
      -- { "<leader>da", function() require("debugHelper").attach() end },
      -- { "<leader>dA", function() require("debugHelper").attachToRemote() end },
      { "<f5>", function() require("dap").continue() end, desc = "Continue" },
      { "<f10>", function() require("dap").step_over() end, desc = "Step Over" },
      { "<f11>", function() require("dap").step_into()() end, desc = "Step Into" },
      { "<s-f11>", function() require("dap").step_out()() end, desc = "Step Out" },
      { "<c-s-f5>", function() require("dap").restart() end },
      { "<s-f5>", function() require("dap").stop() end, desc = "Stop" },
      -- stylua: ignore end
    },
    init = function()
      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ", texthl = "DiagnosticHint" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DapStopped", { text = "➜", texthl = "DiagnosticError" })
    end,
    config = function()
      local dap = require("dap")
      dap.configurations = vim.tbl_extend("force", dap.configurations, configurations)
      dap.adapters = vim.tbl_extend("force", dap.adapters, adapters)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    config = function(_, opts)
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui"] = function()
        dapui.close()
      end
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup(opts)
    end,
    opts = {
      commented = true,
    },
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {},
  },
  {
    "leoluz/nvim-dap-go",
    config = function(_, opts)
      require("dap-go").setup(opts)
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      automatic_setup = true,
      automatic_installation = true,
      ensure_installed = {
        "bash-debug-adapter",
        "cpptools",
        "debugpy",
        "delve",
      },
    },
  },
  {
    "mfussenegger/nvim-dap-python",
    config = function(_, _)
      require("dap-python").setup()
    end,
  },
  {
    "williamboman/mason.nvim",
    keys = {
      { "<leader>cm", false },
      { "<leader>m", "<cmd>Mason<cr>" },
    },
    opts = {
      ui = { border = "rounded" },
    },
  },
}
