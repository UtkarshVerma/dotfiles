---@class util.fs
local M = {}

-- Normalize {path} by expanding "~" and removing trailing slashes.
---@param path string
---@return string
---@nodiscard
function M.normalize_path(path)
  local path_sep = package.config:sub(1, 1)

  -- Resolve relative paths.
  path = vim.loop.fs_realpath(path) or path

  -- Expand tilde.
  if path:sub(1, 1) == "~" then
    local home = assert(vim.loop.os_homedir())
    if home:sub(-1) == path_sep then
      home = home:sub(1, -2)
    end

    path = home .. path:sub(2)
  end

  -- Remove trailing slashes.
  path = path:sub(-1) == path_sep and path:sub(1, -2) or path

  return path
end

-- Get the current working directory.
---@return string?
---@nodiscard
function M.cwd()
  local cwd = vim.loop.cwd()
  if cwd == nil then
    return nil
  end

  return M.normalize_path(cwd)
end

-- Get the file path for buffer {bufnr}.
---@param bufnr integer
---@return string
---@nodiscard
function M.buffer_path(bufnr)
  return M.normalize_path(vim.api.nvim_buf_get_name(bufnr))
end

return M
