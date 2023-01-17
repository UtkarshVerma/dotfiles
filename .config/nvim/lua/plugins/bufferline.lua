return {
  "akinsho/nvim-bufferline.lua",
  event = "VeryLazy",
  init = function()
    vim.keymap.set("n", "<c-s-tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
    vim.keymap.set("n", "<c-tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })

    vim.keymap.set("n", "<leader>b[", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous" })
    vim.keymap.set("n", "<leader>b]", "<cmd>BufferLineCycleNext<cr>", { desc = "Next" })
  end,
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      always_show_bufferline = false,
      diagnostics_indicator = function(_, _, diag)
        local icons = require("config.icons").diagnostics
        local ret = (diag.error and icons.Error .. diag.error .. " " or "")
          .. (diag.warning and icons.Warn .. diag.warning or "")
        return vim.trim(ret)
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          highlight = "Directory",
          text_align = "left",
        },
      },
    },
  },
}
