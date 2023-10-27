---@class util.toggle
local M = {}

---@param silent boolean?
---@param values? {[1]:any, [2]:any}
function M.option(option, silent, values)
  local util = require("util")

  if values then
    if vim.opt_local[option]:get() == values[1] then
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[2]
    else
      ---@diagnostic disable-next-line: no-unknown
      vim.opt_local[option] = values[1]
    end
    return util.info("Set " .. option .. " to " .. vim.opt_local[option]:get(), { title = "Option" })
  end
  ---@diagnostic disable-next-line: no-unknown
  vim.opt_local[option] = not vim.opt_local[option]:get()
  if not silent then
    if vim.opt_local[option]:get() then
      util.info("Enabled " .. option, { title = "Option" })
    else
      util.warn("Disabled " .. option, { title = "Option" })
    end
  end
end

local nu = { number = true, relativenumber = true }
function M.number()
  local util = require("util")

  if vim.opt_local.number:get() or vim.opt_local.relativenumber:get() then
    nu = { number = vim.opt_local.number:get(), relativenumber = vim.opt_local.relativenumber:get() }
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    util.warn("Disabled line numbers", { title = "Option" })
  else
    vim.opt_local.number = nu.number
    vim.opt_local.relativenumber = nu.relativenumber
    util.info("Enabled line numbers", { title = "Option" })
  end
end

local enabled = true
function M.diagnostics()
  enabled = not enabled
  if enabled then
    vim.diagnostic.enable()
    util.info("Enabled diagnostics", { title = "Diagnostics" })
  else
    vim.diagnostic.disable()
    util.warn("Disabled diagnostics", { title = "Diagnostics" })
  end
end

return M
