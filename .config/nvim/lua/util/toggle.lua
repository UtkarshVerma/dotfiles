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

  ---@type vim.diagnostic.Filter
  local filter = { bufnr = bufnr }

  local was_enabled = vim.diagnostic.is_enabled(filter)
  vim.diagnostic.enable(not was_enabled, filter)
  if was_enabled then
    util.log.warn("Disabled diagnostics", "Diagnostics")
  else
    util.log.info("Enabled diagnostics", "Diagnostics")
  end
end

-- Toggle inlay hints for buffer {bufnr}.
---@param bufnr? integer
function M.inlay_hints(bufnr)
  ---@type vim.lsp.inlay_hint.enable.Filter
  local filter = { bufnr = bufnr }
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(filter), filter)
end

return M
