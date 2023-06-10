return {
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
        { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
        { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },
  {
    "akinsho/bufferline.nvim",
    dependencies = { "mini.bufremove" },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<c-s-tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<c-tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    },
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        options = {
          separator_style = "slant", -- | "thick" | "thin" | { 'any', 'any' },
          indicator = {
            style = "underline",
          },
          close_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          diagnostics_indicator = function(count, _, _, _)
            if count > 9 then
              return "9+"
            end
            return tostring(count)
          end,
          hover = {
            enabled = true,
            delay = 0,
            reveal = { "close" },
          },
          always_show_bufferline = false,
        },
      })
    end,
  },
}
