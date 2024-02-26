---@class util.toggle
local M = {}

-- Toggle {option} between {values} or `true`/`false` for the current buffer.
---@generic T
---@param option string
---@param values? {[1]: T, [2]: T}
function M.option(option, values)
  local util = require("util")

  if values then
    if vim.opt_local[option]:get() == values[1] then
      vim.opt_local[option] = values[2]
    else
      vim.opt_local[option] = values[1]
    end

    util.log.info(string.format("Set %s to %s", option, vim.opt_local[option]:get()), "Option")
    return
  end

  vim.opt_local[option] = not vim.opt_local[option]:get()
  if vim.opt_local[option]:get() then
    util.log.info("Enabled " .. option, "Option")
  else
    util.log.warn("Disabled " .. option, "Option")
  end
end

-- Toggle diagnostics for buffer {bufnr} or globally if {bufnr} is omitted.
---@param bufnr? integer
function M.diagnostics(bufnr)
  local util = require("util")

  local is_disabled = vim.diagnostic.is_disabled(bufnr)
  if is_disabled then
    vim.diagnostic.enable(bufnr)
    util.log.info("Enabled diagnostics", "Diagnostics")
  else
    vim.diagnostic.disable(bufnr)
    util.log.warn("Disabled diagnostics", "Diagnostics")
  end
end

return M
