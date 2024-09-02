---@class plugins.chatgpt.config
---@field api_key_cmd? string

---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      spec = {
        { "<leader>ag", group = "chatGPT" },
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
      { "<leader>aga", "<cmd>ChatGPT<cr>", desc = "Open ChatGPT" },
      { "<leader>age", "<cmd>ChatGPTEditWithInstruction<cr>", mode = { "n", "v" }, desc = "Edit with instructions" },
      { "<leader>agg", "<cmd>ChatGPTRun grammar_correction<cr>", mode = { "n", "v" }, desc = "Grammar correction" },
      { "<leader>agt", "<cmd>ChatGPTRun translate<cr>", mode = { "n", "v" }, desc = "Translate" },
      { "<leader>agk", "<cmd>ChatGPTRun keywords<cr>", mode = { "n", "v" }, desc = "Keywords" },
      { "<leader>agd", "<cmd>ChatGPTRun docstring<cr>", mode = { "n", "v" }, desc = "Docstring" },
      { "<leader>agT", "<cmd>ChatGPTRun add_tests<cr>", mode = { "n", "v" }, desc = "Add tests" },
      { "<leader>ago", "<cmd>ChatGPTRun optimise_code<cr>", mode = { "n", "v" }, desc = "Optimize code" },
      { "<leader>ags", "<cmd>ChatGPTRun summarize<cr>", mode = { "n", "v" }, desc = "Summarize" },
      { "<leader>agf", "<cmd>ChatGPTRun fix_bugs<cr>", mode = { "n", "v" }, desc = "Fix bugs" },
      { "<leader>agx", "<cmd>ChatGPTRun explain_code<cr>", mode = { "n", "v" }, desc = "Explain code" },
      { "<leader>agR", "<cmd>ChatGPTRun roxygen_edit<cr>", mode = { "n", "v" }, desc = "Roxygen edit" },
      {
        "<leader>agr",
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
