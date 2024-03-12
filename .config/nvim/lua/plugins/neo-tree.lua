---@class plugins.neo_tree.state
---@field tree? NuiTree

---@class plugins.neo_tree.event
---@field event string
---@field handler fun(state:plugins.neo_tree.state)

---@class plugins.neo_tree.components.indent
---@field with_expanders? boolean
---@field expander_collapsed? string
---@field expander_expanded? string

---@class plugins.neo_tree.config.default_component_configs
---@field indent? {with_expanders?: boolean, expander_collapsed?: string, expander_expanded?: string}
---@field icon? table<"folder_closed"|"folder_open"|"folder_empty"|"folder_empty_open", string>
---@field modified? {symbol?: string}
---@field git_status? {symbols?: table<"added"|"deleted"|"modified"|"renamed"|"untracked"|"ignored"|"unstaged"|"staged"|"conflict", string>}

---@class plugins.neo_tree.window
---@field mappings? table<string, string|boolean|{[1]:string|fun(state:plugins.neo_tree.state), config?: table}>

---@class plugins.neo_tree.sources.filesystem
---@field window? plugins.neo_tree.window
---@field filtered_items? {hide_dotfiles?: boolean, hide_gitignored?: boolean}
---@field follow_current_file? {enabled?: boolean}

---@class plugins.neo_tree.config
---@field sources? string[]
---@field popup_border_style? util.ui.border.chars
---@field event_handlers? plugins.neo_tree.event[]
---@field default_component_configs? plugins.neo_tree.config.default_component_configs
---@field window? plugins.neo_tree.window
---@field filesystem? plugins.neo_tree.sources.filesystem

local icons = require("config").icons
local util = require("util")

---Hide the cursor.
local function hide_cursor()
  vim.opt_local.guicursor = "n:block-Cursor"
  vim.cmd([[hi Cursor blend=100]])
end

---Show the cursor.
local function show_cursor()
  vim.opt_local.guicursor = vim.api.nvim_get_option_info("guicursor").default
  vim.cmd([[hi Cursor blend=0]])
end

---Focus parent directory if focused node is a file, otherwise collapse it.
---@param state plugins.neo_tree.state
local function parent_or_collapse(state)
  local node = state.tree:get_node()
  if node == nil then
    return
  end

  if (node.type == "directory" or node:has_children()) and node:is_expanded() then
    require("neo-tree.sources.filesystem.commands").toggle_node(state)
    return
  end

  require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
end

---Expand focused node if it is a directory, otherwise open it.
---@param state plugins.neo_tree.state
local function child_or_expand(state)
  local node = state.tree:get_node()
  if node == nil then
    return
  end

  local fs_commands = require("neo-tree.sources.filesystem.commands")

  if node.type == "directory" or node:has_children() then
    if not node:is_expanded() then
      fs_commands.toggle_node(state)
      return
    end

    require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
    return
  end

  fs_commands.open(state)
end

---@type LazyPluginSpec[]
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    branch = "v3.x",
    dependencies = {
      "nui.nvim",
      "plenary.nvim",
      "nvim-web-devicons",
    },
    keys = {
      -- stylua: ignore
      { "<leader>fe", function() require("neo-tree.command").execute({ toggle = true }) end, desc = "Explorer" },
    },
    init = function(_)
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(tostring(vim.fn.argv(0)))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    ---@type plugins.neo_tree.config
    opts = {
      sources = { "filesystem" },
      popup_border_style = util.ui.borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
      event_handlers = {
        { event = "neo_tree_window_after_open", handler = hide_cursor },
        -- stylua: ignore
        -- HACK: https://github.com/nvim-neo-tree/neo-tree.nvim/issues/1211
        { event = "neo_tree_window_after_close", handler = function() vim.cmd("do WinEnter") end },
        { event = "neo_tree_buffer_enter", handler = hide_cursor },
        { event = "neo_tree_window_before_close", handler = show_cursor },
        { event = "neo_tree_buffer_leave", handler = show_cursor },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = icons.misc.ChevronRight,
          expander_expanded = icons.misc.ChevronDown,
        },
        icon = {
          folder_closed = icons.misc.FolderClosed,
          folder_open = icons.misc.FolderOpen,
          folder_empty = icons.misc.FolderEmpty,
          folder_empty_open = icons.misc.FolderEmptyOpen,
        },
        modified = { symbol = icons.misc.Modified },
        git_status = { symbols = icons.git },
      },
      window = {
        mappings = {
          ["<space>"] = false,
          ["l"] = { child_or_expand },
          ["h"] = { parent_or_collapse },
        },
      },
      filesystem = {
        window = {
          mappings = {
            ["H"] = "navigate_up",
            ["."] = "set_root",
            ["/"] = "fuzzy_finder",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["a"] = { "add", config = { show_path = "relative" } },
          },
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
      },
    },
  },
}
