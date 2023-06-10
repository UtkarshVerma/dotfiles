local icons = require("config").icons

return {
  {
    "lewis6991/gitsigns.nvim",
    cmd = "Gitsigns",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "]h", "<cmd>Gitsigns next_hunk<cr>", desc = "Next Hunk" },
      { "[h", "<cmd>Gitsigns prev_hunk<cr>", desc = "Prev Hunk" },
      { mode = { "n", "v" }, "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage Hunk" },
      { mode = { "n", "v" }, "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset Hunk" },
      { "<leader>ghS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage Buffer" },
      { "<leader>ghu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Undo Stage Hunk" },
      { "<leader>ghR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset Buffer" },
      { "<leader>ghp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview Hunk" },
      { "<leader>ghb", "<cmd>Gitsigns blame_line<cr>", desc = "Blame Line" },
      { "<leader>ghd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff This" },
      { mode = { "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>", desc = "GitSigns Select Hunk" },
    },
    opts = {
      signs = {
        add = { text = icons.gitsigns.add },
        change = { text = icons.gitsigns.change },
        delete = { text = icons.gitsigns.delete },
        topdelete = { text = icons.gitsigns.topdelete },
        changedelete = { text = icons.gitsigns.changedelete },
        untracked = { text = icons.gitsigns.untracked },
      },
    },
  },
}
