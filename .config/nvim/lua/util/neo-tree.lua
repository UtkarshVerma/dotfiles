---@class util.neo_tree
local M = {}

-- Hide the cursor.
function M.hide_cursor()
  vim.opt_local.guicursor = "n:block-Cursor"
  vim.cmd([[hi Cursor blend=100]])
end

-- Show the cursor.
function M.show_cursor()
  vim.opt_local.guicursor = vim.api.nvim_get_option_info("guicursor").default
  vim.cmd([[hi Cursor blend=0]])
end

---@class util.neo_tree.state
---@field tree NuiTree

-- Focus parent directory if focused node is a file, otherwise collapse it.
---@param state util.neo_tree.state
---@return boolean
function M.parent_or_collapse(state)
  local node = state.tree:get_node()
  if node == nil then
    return false
  end

  if (node.type == "directory" or node:has_children()) and node:is_expanded() then
    require("neo-tree.sources.filesystem.commands").toggle_node(state)
    return true
  end

  return require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
end

-- Expand focused node if it is a directory, otherwise open it.
---@param state util.neo_tree.state
---@return boolean
function M.child_or_expand(state)
  local node = state.tree:get_node()
  if node == nil then
    return false
  end

  local fs_commands = require("neo-tree.sources.filesystem.commands")

  if node.type == "directory" or node:has_children() then
    if not node:is_expanded() then
      fs_commands.toggle_node(state)
      return true
    end

    return require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
  end

  fs_commands.open(state)
  return true
end

return M
