---@class util.toggle
local M = {}

local config = {
  ---@type {number: boolean, relativenumber: boolean}
  nu = { number = true, relativenumber = true },

  ---@type boolean
  diagnostics = true,
}

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

    util.log.info(("Set %s to %s"):format(option, vim.opt_local[option]:get()), "Option")
    return
  end

  vim.opt_local[option] = not vim.opt_local[option]:get()
  if vim.opt_local[option]:get() then
    util.log.info("Enabled " .. option, "Option")
  else
    util.log.warn("Disabled " .. option, "Option")
  end
end

-- Toggle line numbers.
function M.number()
  local util = require("util")

  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    config.nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    util.log.warn("Disabled line numbers", "Option")
  else
    vim.opt_local.number = config.nu.number
    vim.opt_local.relativenumber = config.nu.relativenumber
    util.log.info("Enabled line numbers", "Option")
  end
end

-- Toggle diagnostics.
function M.diagnostics()
  local util = require("util")

  config.diagnostics = not config.diagnostics
  if config.diagnostics then
    vim.diagnostic.enable()
    util.log.info("Enabled diagnostics", "Diagnostics")
  else
    vim.diagnostic.disable()
    util.log.warn("Disabled diagnostics", "Diagnostics")
  end
end

return M
