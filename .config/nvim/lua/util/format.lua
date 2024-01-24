---@class util.format
local M = {}

---@class util.format.formatter
---@field name string
---@field format fun(bufnr?:integer)
---@field sources fun(bufnr?:integer):string[]
---@field priority integer

---@type util.format.formatter[]
local formatters = {}

local config = {
  ---@type table<integer, boolean?>
  buffer = {},
  ---@type boolean
  global = true,
}

-- Check if buffer {bufnr} can be formatted.
---@param bufnr? integer
---@return boolean
---@nodiscard
local function can_format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local buffer_autoformat = config.buffer[bufnr]

  if buffer_autoformat ~= nil then
    return buffer_autoformat
  end

  return config.global
end

-- Display autoformat status for buffer {bufnr}.
---@param bufnr? integer
local function show_status(bufnr)
  local util = require("util")

  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local buffer_autoformat = config.buffer[bufnr]
  local global_autoformat = config.global
  local enabled = can_format(bufnr)
  local lines = {
    (enabled and "enabled" or "disabled"),
    ("- [%s] global (%s)"):format(global_autoformat and "x" or " ", global_autoformat and "enabled" or "disabled"),
    ("- [%s] buffer (%s)"):format(
      enabled and "x" or " ",
      buffer_autoformat == nil and "inherit" or buffer_autoformat and "enabled" or "disabled"
    ),
  }

  local has_formatter = false
  for _, formatter in ipairs(formatters) do
    local sources = formatter.sources(bufnr)
    local is_active = #sources > 0 and not has_formatter
    has_formatter = has_formatter or is_active

    if #sources > 0 then
      lines[#lines + 1] = ("\n# %s%s"):format(formatter.name, (is_active and " (active)" or ""))
      for _, source in ipairs(sources) do
        lines[#lines + 1] = ("- %s"):format(source)
      end
    end
  end

  if not has_formatter then
    lines[#lines + 1] = "\nNo formatters available for this buffer."
  end

  local message = table.concat(lines, "\n")
  local title = "Format"
  if enabled then
    util.log.info(message, title)
  else
    util.log.warn(message, title)
  end
end

-- Register {formatter} to the formatters list.
---@param formatter util.format.formatter
function M.register(formatter)
  formatters[#formatters + 1] = formatter

  table.sort(formatters, function(a, b)
    return a.priority > b.priority
  end)
end

-- Get the `formatexpr` for the active formatter.
---@return integer
---@nodiscard
function M.formatexpr()
  local util = require("util")

  if util.plugin.exists("conform.nvim") then
    return require("conform").formatexpr()
  end

  return vim.lsp.formatexpr({ timeout_ms = 3000 })
end

-- Toggle formatting for {mode}.
---@param mode? "buffer" | "global"
function M.toggle(mode)
  mode = mode or "global"
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = can_format()

  if mode == "buffer" then
    config.buffer[bufnr] = not enabled
  else
    config.global = not enabled
    config.buffer[bufnr] = nil
  end

  show_status(bufnr)
end

-- Format buffer {bufnr}.
---@param opts? {force?:boolean, bufnr?:integer}
function M.format(opts)
  local util = require("util")

  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local force = opts.force or false
  if not (force or can_format(bufnr)) then
    return
  end

  for _, formatter in ipairs(formatters) do
    if #formatter.sources(bufnr) > 0 then
      util.try(function()
        formatter.format(bufnr)
      end, ("Formatter `%s` failed"):format(formatter.name))

      return
    end
  end

  if force then
    util.log.warn("No formatter available", "Format")
  end
end

function M.setup()
  local util = require("util")

  local group = vim.api.nvim_create_augroup("Format", {})
  util.create_autocmd("BufWritePre", {
    desc = "Format on save",
    group = group,
    callback = function(args)
      M.format({ bufnr = args.buf })
    end,
  })

  util.create_autocmd("BufDelete", {
    desc = "Reset formatter buffer variables on buffer delete",
    group = group,
    callback = function(arg)
      config.buffer[arg.buf] = nil
    end,
  })

  vim.api.nvim_create_user_command("Format", function()
    M.format({ force = true })
  end, { desc = "Format selection or buffer" })

  vim.api.nvim_create_user_command(
    "FormatInfo",
    show_status,
    { desc = "Show info about the formatters for the current buffer" }
  )
end

return M
