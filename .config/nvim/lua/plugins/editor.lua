return {
  {
    "NMAC427/guess-indent.nvim",
    event = "LazyFile",
    opts = {},
  },

  {
    "nvim-pack/nvim-spectre",
    cmd = "Spectre",
    opts = {
      open_cmd = "noswapfile vnew",
    },
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
    "RRethy/vim-illuminate",
    event = "LazyFile",
    keys = {
      { "]]", desc = "Next reference" },
      { "[[", desc = "Prev reference" },
    },
    opts = {
      delay = 200,
      filetypes_denylist = {
        "harpoon",
        "markdown",
      },
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " reference", buffer = buffer })
      end

      map("]]", "next")
      map("[[", "prev")

      -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
  },

  {
    "folke/todo-comments.nvim",
    dependencies = { "trouble.nvim" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "LazyFile",
    keys = {
      { "]t", "<cmd>lua require('todo-comments').jump_next()<cr>", desc = "Next todo comment" },
      { "[t", "<cmd>lua require('todo-comments').jump_prev()<cr>", desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/fix/fixme (trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
      { "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/fix/fixme" },
    },
    opts = {},
  },
}
