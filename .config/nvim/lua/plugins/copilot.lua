---@module "copilot"
---@module "snacks"

---@class plugins.copilot_chat.config: CopilotChat.config
---@class plugins.copilot.config: copilot_config

local is_enabled = false

---@type LazyPluginSpec[]
return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "BufReadPost",
    keys = {
      { "<leader>as", "<cmd>Copilot toggle<cr>", desc = "Toggle copilot", mode = { "n", "v" } },
    },
    ---@type plugins.copilot.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<c-j>",
        },
      },
    },
    ---@param opts plugins.copilot.config
    config = function(_, opts)
      Snacks.toggle
        .new({
          name = "Copilot",
          get = function()
            if not is_enabled then
              return false
            end

            return not require("copilot.client").is_disabled()
          end,
          set = function(state)
            if state then
              require("copilot").setup(opts)
              require("copilot.command").enable()
              is_enabled = true
            else
              require("copilot.command").disable()
              is_enabled = false
            end
          end,
        })
        :map("<leader>ac", { desc = "Toggle copilot" })
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
