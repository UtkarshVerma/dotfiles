---@class plugins.neotest.config: neotest.Config
---@field adapters? table<string, table>

---@type LazyPluginSpec[]
return {
  {
    "catppuccin",
    ---@type plugins.catppuccin.config
    opts = {
      integrations = {
        neotest = true,
      },
    },
  },

  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      spec = {
        { "<leader>T", group = "test" },
      },
    },
  },

  {
    "nvim-neotest/neotest",
    keys = {
      -- stylua: ignore start
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "File" },
      { "<leader>TF", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "All files" },
      { "<leader>Tn", function() require("neotest").run.run() end, desc = "Nearest" },
      { "<leader>Tl", function() require("neotest").run.run_last() end, desc = "Run last" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show output" },
      { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
      { "<leader>TS", function() require("neotest").run.stop() end, desc = "Stop" },
      { "<leader>Tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle watch" },
      ---@diagnostic disable-next-line: missing-fields
      { "<leader>Td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest" },
      -- stylua: ignore end
    },
    dependencies = {
      "nvim-neotest/nvim-nio",
      "plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-dap",
      "nvim-treesitter",
    },
    ---@type plugins.neotest.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      adapters = {},
      ---@diagnostic disable-next-line: missing-fields
      output = {
        open_on_run = false,
      },
    },
    config = function(_, opts)
      opts.adapters = vim
        .iter(opts.adapters)
        :map(function(name, config)
          local adapter = require(name)
          if not vim.tbl_isempty(config) then
            return adapter(config)
          end

          return adapter
        end)
        :totable()

      require("neotest").setup(opts)
    end,
  },
}
