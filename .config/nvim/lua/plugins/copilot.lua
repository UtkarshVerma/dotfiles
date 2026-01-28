---@module "copilot"
---@module "snacks"

---@class plugins.copilot_chat.config: CopilotChat.config.Config
---@class plugins.copilot.config: CopilotConfig

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
    ---@diagnostic disable: missing-fields
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
    ---@diagnostic enable: missing-fields

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
}
