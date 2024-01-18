return {
  {
    "which-key.nvim",
    opts = {
      defaults = {
        ["<leader>t"] = { name = "+trailspace" },
      },
    },
  },

  {
    "echasnovski/mini.trailspace",
    keys = {
      {
        "<leader>tw",
        function()
          require("mini.trailspace").trim()
        end,
        desc = "Trim trailing whitespaces",
      },
      {
        "<leader>tl",
        function()
          require("mini.trailspace").trim_last_lines()
        end,
        desc = "Trim trailing lines",
      },
    },
    opts = {},
  },
}
