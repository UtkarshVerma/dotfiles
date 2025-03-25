---@class plugins.copilot_chat.config: CopilotChat.config

---@type LazyPluginSpec[]
return {
  {
    "blink.cmp",
    dependencies = {
      "giuxtaposition/blink-cmp-copilot",
    },
    ---@type plugins.blink.config
    opts = {
      sources = {
        default = { "copilot" },
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
    },
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "copilot.lua",
      "plenary.nvim",
    },
    cmd = "CopilotChat",
    keys = {
      { "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "Toggle chat", mode = { "n", "v" } },
      { "<leader>ax", "<cmd>CopilotChatReset<cr>", desc = "Clear chat", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>CopilotChatPrompts<cr>", desc = "Prompt actions", mode = { "n", "v" } },
      {
        "<leader>aq",
        function()
          vim.ui.input({
            prompt = "Quick Chat: ",
          }, function(input)
            if input ~= "" then
              require("CopilotChat").ask(input)
            end
          end)
        end,
        desc = "Quick chat",
        mode = { "n", "v" },
      },
    },
    ---@type plugins.copilot_chat.config
    opts = {
      auto_insert_mode = true,
      question_header = "  User ",
      answer_header = "  Copilot ",
      window = {
        width = 0.4,
      },
    },
    ---@param opts plugins.copilot_chat.config
    config = function(_, opts)
      local chat = require("CopilotChat")

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
}
