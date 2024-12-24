---@class util.fs
local M = {}

M.path_sep = package.config:sub(1, 1)

---Normalize slashes in {path}, expand "~" and remove trailing slashes.
---@param path string
---@return string
---@nodiscard
function M.normalize(path)
  -- Resolve relative paths.
  path = vim.uv.fs_realpath(path) or path

  -- Expand tilde, normalize slashes and removing trailing ones.
  path = vim.fs.normalize(path)

  return path
end

---Get the current working directory.
---@return string?
---@nodiscard
function M.cwd()
  local cwd = vim.uv.cwd()
  if cwd == nil then
    return nil
  end

  return M.normalize(cwd)
end

return M
