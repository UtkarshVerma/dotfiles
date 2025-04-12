---@module "snacks"
---@class plugins.snacks.config: snacks.Config

---@type LazyPluginSpec[]
return {
  {
    "catppuccin",
    ---@type plugins.catppuccin.config
    opts = {
      integrations = {
        snacks = true,
      },
    },
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      -- stylua: ignore start
      { "<leader>gl", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>tt", function() Snacks.terminal.toggle() end, desc = "Terminal" },

      -- Git
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Status" },

      -- Search
      { "<leader>sr", function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Auto commands" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command history" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics({ bufnr = 0 }) end, desc = "Document diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Workspace diagnostics" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Search highlight groups" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man pages" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Jump to mark" },

      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config files" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Files" },

      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Word" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Goto symbol" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Goto symbol (workspace)" },

      { "<leader>uc", function() Snacks.picker.colorschemes() end, desc = "Colorscheme" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      -- stylua: ignore end
      ---@diagnostic disable-next-line: assign-type-mismatch
    },
    ---@type plugins.snacks.config
    opts = {
      bigfile = { enabled = true },
      lazygit = { enabled = true },
      toggle = { enabled = true, which_key = false },
      terminal = {
        ---@diagnostic disable-next-line: missing-fields
        win = {
          wo = {
            winbar = "", -- Disable winbar.
          },
        },
      },
      picker = {},
    },
    config = function(_, opts)
      require("snacks").setup(opts)

      Snacks.toggle.option("spell"):map("<leader>ts", { desc = "Spelling" })
      Snacks.toggle.option("wrap"):map("<leader>tw", { desc = "Word wrap" })
      Snacks.toggle.diagnostics():map("<leader>td", { desc = "Diagnostics" })
    end,
  },
}
