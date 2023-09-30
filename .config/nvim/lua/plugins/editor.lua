return {
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = {
        "buffers",
        "curdir",
        "tabpages",
        "winsize",
        "help",
        "globals",
        "skiprtp",
      },
    },
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  {
    "NMAC427/guess-indent.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = { open_cmd = "noswapfile vnew" },
    keys = {
      {
        "<leader>sr",
        function()
          require("spectre").open()
        end,
        desc = "Replace in files (Spectre)",
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        plugins = {
          spelling = true,
          presets = { motions = false, g = false }, -- This fix mapping for fold when press f and nothing show up
        },
        layout = {
          height = { min = 3, max = 25 }, -- min and max height of the columns
          width = { min = 20, max = 50 }, -- min and max width of the columns
          spacing = 5, -- spacing between columns
          align = "center", -- align columns left, center or right
        },
        window = {
          margin = { 1, 0, 2, 0 }, -- extra window margin [top, right, bottom, left]
          padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
          winblend = 5, -- value between 0-100 0 for fully opaque and 100 for fully transparent
        },
        defaults = {
          mode = { "n", "v" },
          ["g"] = { name = "+goto" },
          ["gz"] = { name = "+surround" },
          ["]"] = { name = "+next" },
          ["["] = { name = "+prev" },
          ["<leader><tab>"] = { name = "+tabs" },
          ["<leader>b"] = { name = "+buffer" },
          ["<leader>c"] = { name = "+code" },
          ["<leader>d"] = { name = "+debug" },
          ["<leader>f"] = { name = "+file/find" },
          ["<leader>g"] = { name = "+git" },
          ["<leader>gh"] = { name = "+hunks" },
          ["<leader>q"] = { name = "+quit/session" },
          ["<leader>s"] = { name = "+search" },
          ["<leader>u"] = { name = "+ui" },
          ["<leader>w"] = { name = "+windows" },
          ["<leader>x"] = { name = "+diagnostics/quickfix" },
        },
      })
    end,
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },
  {
    "mbbill/undotree",
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "]t", "<cmd>lua require('todo-comments').jump_next()<cr>", desc = "Next todo comment" },
      { "[t", "<cmd>lua require('todo-comments').jump_prev()", desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
    },
    opts = {},
  },
}
