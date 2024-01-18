---@class util.format
local M = {}

---@class Formatter
---@field name string
---@field primary? boolean
---@field format fun(bufnr:integer)
---@field sources fun(bufnr:integer):string[]
---@field priority integer

---@type Formatter[]
M.formatters = {}

---@type table<integer, boolean?>
local buffer_autoformat_map = {}

local global_autoformat = true

---@param formatters Formatter[]
---@param bufnr? integer
local function resolve_formatters(formatters, bufnr)
  local have_primary = false
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  ---@param formatter Formatter
  return vim.tbl_map(function(formatter)
    local sources = formatter.sources(bufnr)
    local active = #sources > 0 and (not formatter.primary or not have_primary)
    have_primary = have_primary or (active and formatter.primary) or false

    return setmetatable({
      active = active,
      resolved = sources,
    }, { __index = formatter })
  end, formatters)
end

---@param bufnr? integer
---@return boolean
local function can_format(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local buffer_autoformat = buffer_autoformat_map[bufnr]

  if buffer_autoformat ~= nil then
    return buffer_autoformat
  end

  return global_autoformat
end

---@param formatter Formatter
function M.register(formatter)
  M.formatters[#M.formatters + 1] = formatter

  table.sort(M.formatters, function(a, b)
    return a.priority > b.priority
  end)
end

---@return integer
function M.formatexpr()
  local util = require("util")

  if util.has("conform.nvim") then
    return require("conform").formatexpr()
  end

  return vim.lsp.formatexpr({ timeout_ms = 3000 })
end

---@param bufnr? integer
function M.info(bufnr)
  local util = require("util")

  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local buffer_autoformat = buffer_autoformat_map[bufnr]
  local enabled = can_format(bufnr)
  local lines = {
    "# Status",
    ("- [%s] global **%s**"):format(global_autoformat and "x" or " ", global_autoformat and "enabled" or "disabled"),
    ("- [%s] buffer **%s**"):format(
      enabled and "x" or " ",
      buffer_autoformat == nil and "inherit" or buffer_autoformat and "enabled" or "disabled"
    ),
  }
  local have = false
  for _, formatter in ipairs(resolve_formatters(M.formatters, bufnr)) do
    if #formatter.resolved > 0 then
      have = true
      lines[#lines + 1] = "\n# " .. formatter.name .. (formatter.active and " ***(active)***" or "")
      for _, line in ipairs(formatter.resolved) do
        lines[#lines + 1] = ("- [%s] **%s**"):format(formatter.active and "x" or " ", line)
      end
    end
  end
  if not have then
    lines[#lines + 1] = "\n***No formatters available for this buffer.***"
  end
  util[enabled and "info" or "warn"](
    table.concat(lines, "\n"),
    { title = "Format (" .. (enabled and "enabled" or "disabled") .. ")" }
  )
end

---@param kind? "buffer" | "global"
function M.toggle(kind)
  kind = kind or "global"
  local bufnr = vim.api.nvim_get_current_buf()

  if kind == "buffer" then
    buffer_autoformat_map[bufnr] = not can_format()
  else
    global_autoformat = not can_format()
    buffer_autoformat_map[bufnr] = nil
  end

  M.info()
end

---@param opts? {force?:boolean, bufnr?:integer}
function M.format(opts)
  local util = require("util")

  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local force = opts.force or false
  if not (force or can_format(bufnr)) then
    return
  end

  local done = false
  for _, formatter in ipairs(resolve_formatters(M.formatters, bufnr)) do
    if formatter.active then
      done = true
      util.try(function()
        return formatter.format(bufnr)
      end, { msg = "Formatter `" .. formatter.name .. "` failed" })
    end
  end

  if not done and force then
    util.warn("No formatter available", { title = "Editor" })
  end
end

---@alias Event {buf?: integer}

function M.setup()
  local group = vim.api.nvim_create_augroup("Format", {})

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,

    ---@param event Event
    callback = function(event)
      M.format({ bufnr = event.buf })
    end,
  })

  -- Reset buffer variables on buffer delete
  vim.api.nvim_create_autocmd("BufDelete", {
    group = group,

    ---@param event Event
    callback = function(event)
      buffer_autoformat_map[event.buf] = nil
    end,
  })

  vim.api.nvim_create_user_command("Format", function()
    M.format({ force = true })
  end, { desc = "Format selection or buffer" })

  vim.api.nvim_create_user_command("FormatInfo", function()
    M.info()
  end, { desc = "Show info about the formatters for the current buffer" })
end

return M
