---@class plugins.chatgpt.config
---@field api_key_cmd? string

---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      defaults = {
        ["<leader>a"] = { name = "+ai" },
      },
    },
  },

  {
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "nui.nvim",
      "plenary.nvim",
      "trouble.nvim",
      "telescope.nvim",
    },
    keys = {
      { "<leader>aa", "<cmd>ChatGPT<cr>", desc = "Open ChatGPT" },
      { "<leader>ae", "<cmd>ChatGPTEditWithInstruction<cr>", mode = { "n", "v" }, desc = "Edit with instructions" },
      { "<leader>ag", "<cmd>ChatGPTRun grammar_correction<cr>", mode = { "n", "v" }, desc = "Grammar correction" },
      { "<leader>at", "<cmd>ChatGPTRun translate<cr>", mode = { "n", "v" }, desc = "Translate" },
      { "<leader>ak", "<cmd>ChatGPTRun keywords<cr>", mode = { "n", "v" }, desc = "Keywords" },
      { "<leader>ad", "<cmd>ChatGPTRun docstring<cr>", mode = { "n", "v" }, desc = "Docstring" },
      { "<leader>aT", "<cmd>ChatGPTRun add_tests<cr>", mode = { "n", "v" }, desc = "Add tests" },
      { "<leader>ao", "<cmd>ChatGPTRun optimise_code<cr>", mode = { "n", "v" }, desc = "Optimize code" },
      { "<leader>as", "<cmd>ChatGPTRun summarize<cr>", mode = { "n", "v" }, desc = "Summarize" },
      { "<leader>af", "<cmd>ChatGPTRun fix_bugs<cr>", mode = { "n", "v" }, desc = "Fix bugs" },
      { "<leader>ax", "<cmd>ChatGPTRun explain_code<cr>", mode = { "n", "v" }, desc = "Explain code" },
      { "<leader>aR", "<cmd>ChatGPTRun roxygen_edit<cr>", mode = { "n", "v" }, desc = "Roxygen edit" },
      {
        "<leader>ar",
        "<cmd>ChatGPTRun code_readability_analysis<cr>",
        mode = { "n", "v" },
        desc = "Code readability analysis",
      },
    },
    ---@type plugins.chatgpt.config
    opts = {
      api_key_cmd = "gopass show --password api-keys/openai",
    },
  },
}
