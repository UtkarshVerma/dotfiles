---@module "gitsigns"
---@class plugins.gitsigns.config: Gitsigns.Config

local icons = require("config").icons

---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      spec = {
        { "<leader>gh", group = "hunks" },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    cmd = "Gitsigns",
    event = "LazyFile",
    keys = {
      { "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Next hunk" },
      { "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Previous hunk" },
      { mode = { "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
      { mode = { "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
      { "<leader>ghS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
      { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo stage hunk" },
      { "<leader>ghR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },
      { "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
      { "<leader>ghb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame line" },
      { "<leader>ghd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff this" },
      {
        mode = { "o", "x" },
        "ih",
        ":<c-u>Gitsigns select_hunk<cr>",
        desc = "GitSigns select hunk",
      },
    },
    ---@type plugins.gitsigns.config
    ---@diagnostic disable: missing-fields
    opts = {
      signs = {
        add = { text = icons.gitsigns.Add },
        change = { text = icons.gitsigns.Change },
        delete = { text = icons.gitsigns.Delete },
        topdelete = { text = icons.gitsigns.TopDelete },
        changedelete = { text = icons.gitsigns.ChangeDelete },
        untracked = { text = icons.gitsigns.Untracked },
      },
    },
    ---@diagnostic enable: missing-fields
  },
}
