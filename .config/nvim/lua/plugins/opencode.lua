---@module "opencode"
---@class plugins.opencode.config: opencode.Opts

---@type LazyPluginSpec[]
return {
  {

    "snacks.nvim",
    ---@type plugins.snacks.config
    -- Recommended for `ask()` and `select()`.
    -- Required for `toggle()`.
    opts = {
      input = {},
      picker = {},
    },
  },

  {
    "NickvanDyke/opencode.nvim",
    keys = {
      -- stylua: ignore start
      { "<leader>aa", function() require("opencode").ask("@this: ", { submit = true }) end, desc = "OpenCode: Ask about this", mode = { "n", "x" } },
      { "<leader>as", function() require("opencode").select() end, desc = "OpenCode: Select prompt", mode = { "n", "x" } },
      { "<leader>a+", function() require("opencode").prompt("@this") end, desc = "OpenCode: Add this", mode = { "n", "x" } },
      { "<leader>at", function() require("opencode").toggle() end, desc = "OpenCode: Toggle embedded" },
      { "<leader>aC", function() require("opencode").command() end, desc = "OpenCode: Select command" },
      { "<leader>on", function() require("opencode").command("session_new") end, desc = "OpenCode: New session" },
      { "<leader>ai", function() require("opencode").command("session_interrupt") end, desc = "OpenCode: Interrupt session" },
      { "<leader>aA", function() require("opencode").command("agent_cycle") end, desc = "OpenCode: Cycle selected agent" },
      { "<s-c-u>",    function() require("opencode").command("messages_half_page_up") end, desc = "OpenCode: Messages half page up" },
      { "<s-c-d>",    function() require("opencode").command("messages_half_page_down") end, desc = "OpenCode: Messages half page down" },
      -- stylua: ignore end
    },
    dependencies = {
      "snacks.nvim",
    },
    ---@type plugins.opencode.config
    opts = {},
    config = function(_, opts)
      vim.g.opencode_opts = opts

      -- Required for `vim.g.opencode_opts.auto_reload`.
      vim.opt.autoread = true
    end,
  },
}
