---@class plugins.obsidian.config: obsidian.config.ClientOpts
---@field note_frontmatter_func? fun(note:obsidian.Note):table

local vaults = {
  "~/notes/personal",
  "~/notes/cooking",
  "~/notes/colleges",
  "~/notes/freelancing",
}

---@type obsidian.workspace.WorkspaceSpec[]
local workspaces = vim.tbl_map(function(vault)
  ---@type obsidian.workspace.WorkspaceSpec
  return {
    name = vim.fs.basename(vault),
    path = vim.fn.resolve(vim.fn.expand(vault)),
  }
end, vaults)

---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      spec = {
        { "<leader>n", group = "notes" },
      },
    },
  },

  {
    "epwalsh/obsidian.nvim",
    event = {
      {
        event = { "BufReadPre", "BufNewFile" },
        pattern = vim.tbl_map(function(workspace)
          return string.format("%s/**.md", workspace.path)
        end, workspaces),
      },
    },
    keys = {
      { "<leader>no", "<cmd>ObsidianQuickSwitch<cr>", desc = "Open note" },
      { "<leader>nO", "<cmd>ObsidianOpen<cr>", desc = "Open vault" },
      { "<leader>nw", "<cmd>ObsidianWorkspace<cr>", desc = "Switch workspace" },
      { "<leader>nt", "<cmd>ObsidianTags<cr>", desc = "Search tags" },
      { "<leader>ns", "<cmd>ObsidianSearch<cr>", desc = "Search notes" },
    },
    dependencies = { "plenary.nvim" },
    ---@type plugins.obsidian.config
    opts = {
      workspaces = workspaces,
      disable_frontmatter = true, -- Don't set first heading as an alias.
      note_frontmatter_func = function(note)
        if note.path.filename:match("tags") then
          return note.metadata
        end

        local out = {
          aliases = #note.aliases > 0 and note.aliases or nil,
          tags = #note.tags > 0 and note.tags or nil,
        }

        vim.tbl_extend("force", out, note.metadata or {})

        return out
      end,
    },
  },
}
