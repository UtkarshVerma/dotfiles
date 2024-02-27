local vaults = {
  "~/notes/personal",
  "~/notes/cooking",
  "~/notes/colleges",
}

---@type obsidian.workspace.WorkspaceSpec[]
local workspaces = vim.tbl_map(function(vault)
  ---@type obsidian.workspace.WorkspaceSpec
  return {
    name = vim.fs.basename(vault),
    path = vault,
  }
end, vaults)

---@type LazyEventSpec[]
local events = vim.tbl_flatten(vim.tbl_map(function(workspace)
  return vim.tbl_map(function(event)
    ---@type LazyEventSpec
    return {
      event = event,
      pattern = string.format("%s/**.md", workspace.path),
    }
  end, { "BufReadPre", "BufNewFile" })
end, workspaces))

---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      defaults = {
        ["<leader>o"] = { name = "+obsidian" },
      },
    },
  },

  {
    "epwalsh/obsidian.nvim",
    event = events,
    keys = {
      { "<leader>oo", "<cmd>ObsidianQuickSwitch<cr>", desc = "Open note" },
      { "<leader>oO", "<cmd>ObsidianOpen<cr>", desc = "Open vault" },
      { "<leader>ow", "<cmd>ObsidianWorkspace<cr>", desc = "Switch workspace" },
      { "<leader>ot", "<cmd>ObsidianTags<cr>", desc = "Search tags" },
      { "<leader>os", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    },
    dependencies = { "plenary.nvim" },
    ---@type obsidian.config.ClientOpts
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      workspaces = workspaces,
    },
  },
}
