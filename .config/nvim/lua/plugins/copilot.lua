---@module "copilot"

---@class plugins.copilot_chat.config: CopilotChat.config
---@class plugins.copilot.config: copilot_config

---@type LazyPluginSpec[]
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    ---@type plugins.copilot.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      suggestion = {
        auto_trigger = true,
        keymap = {
          accept = "<c-j>",
        },
      },
    },
    ---@param opts plugins.copilot.config
    config = function(_, opts)
      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuOpen",
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "BlinkCmpMenuClose",
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })

      require("copilot").setup(opts)
    end,
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
