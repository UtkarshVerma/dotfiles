---@class util.lint
local M = {}

---@class util.lint.linter
---@field name string
---@field lint fun(bufnr?:integer)
---@field sources fun(bufnr?:integer):string[]
---@field priority integer

---@type util.lint.linter[]
local linters = {}

local config = {
  ---@type table<integer, boolean?>
  buffer = {},

  ---@type boolean
  global = true,
}

-- Check if linting can be done for buffer {bufnr}.
---@param bufnr? integer
---@return boolean
---@nodiscard
local function can_lint(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local buffer_autolint = config.buffer[bufnr]

  if buffer_autolint ~= nil then
    return buffer_autolint
  end

  return config.global
end

-- Display linting status for buffer {bufnr}.
---@param bufnr? integer
local function show_status(bufnr)
  local util = require("util")

  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local buffer_autolint = config.buffer[bufnr]
  local global_autolint = config.global
  local enabled = can_lint(bufnr)
  local lines = {
    (enabled and "enabled" or "disabled"),
    ("- [%s] global (%s)"):format(global_autolint and "x" or " ", global_autolint and "enabled" or "disabled"),
    ("- [%s] buffer (%s)"):format(
      enabled and "x" or " ",
      buffer_autolint == nil and "inherit" or buffer_autolint and "enabled" or "disabled"
    ),
  }

  local has_linter = false
  for _, linter in ipairs(linters) do
    local sources = linter.sources(bufnr)
    local is_active = #sources > 0 and not has_linter
    has_linter = has_linter or is_active

    if #sources > 0 then
      lines[#lines + 1] = ("\n# %s%s"):format(linter.name, (is_active and " (active)" or ""))
      for _, source in ipairs(sources) do
        lines[#lines + 1] = ("- %s"):format(source)
      end
    end
  end

  if not has_linter then
    lines[#lines + 1] = "\nNo linters available for this buffer."
  end

  local message = table.concat(lines, "\n")
  local title = "Lint"
  if enabled then
    util.log.info(message, title)
  else
    util.log.warn(message, title)
  end
end

-- Register {linter} to the linters list.
---@param linter util.lint.linter
function M.register(linter)
  linters[#linters + 1] = linter

  table.sort(linters, function(a, b)
    return a.priority > b.priority
  end)
end

-- Toggle linting for {mode}.
---@param mode? "buffer"|"global"
function M.toggle(mode)
  mode = mode or "global"
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = can_lint()

  if mode == "buffer" then
    config.buffer[bufnr] = not enabled
  else
    config.global = not enabled
    config.buffer[bufnr] = nil
  end

  show_status(bufnr)
end

-- Lint buffer {bufnr}.
---@param opts? {force?:boolean, bufnr?:integer}
function M.lint(opts)
  local util = require("util")

  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local force = opts.force or false
  if not force and not can_lint(bufnr) then
    return
  end

  for _, linter in ipairs(linters) do
    if #linter.sources(bufnr) > 0 then
      util.try(function()
        linter.lint(bufnr)
      end, ("Linter `%s` failed"):format(linter.name))

      return
    end
  end

  if force then
    util.log.warn("No linter available", "Lint")
  end
end

---@param opts? {events?: util.autocommand.event}
function M.setup(opts)
  opts = opts or {}
  local events = opts.events or { "BufWritePost", "BufReadPost", "InsertLeave" }

  local util = require("util")
  local group = vim.api.nvim_create_augroup("Lint", {})
  util.create_autocmd(events, {
    desc = "Lint",
    group = group,
    callback = function(args)
      M.lint({ bufnr = args.buf })
    end,
  })

  util.create_autocmd("BufDelete", {
    desc = "Reset linter buffer variables on buffer delete",
    group = group,
    callback = function(arg)
      config.buffer[arg.buf] = nil
    end,
  })

  vim.api.nvim_create_user_command("Lint", function()
    M.lint({ force = true })
  end, { desc = "Lint buffer" })

  vim.api.nvim_create_user_command("LintInfo", function()
    show_status()
  end, { desc = "Show info about linters for the current buffer" })
end

return M
