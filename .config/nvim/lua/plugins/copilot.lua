---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      defaults = {
        ["<leader>ac"] = { name = "+copilot" },
      },
    },
  },

  {
    "github/copilot.vim",
    cmd = "Copilot",
    keys = {
      {
        "<c-j>",
        'copilot#Accept("\\<CR>")',
        expr = true,
        replace_keycodes = false,
        mode = "i",
        desc = "Accept Copilot suggestion",
      },
      { "<leader>ace", "<cmd>Copilot enable<cr>", desc = "Enable" },
      { "<leader>acd", "<cmd>Copilot disable<cr>", desc = "Disable" },
      { "<leader>acs", "<cmd>Copilot status<cr>", desc = "Status" },
    },
    init = function(_)
      vim.g.copilot_no_tab_map = true
    end,
  },
}
