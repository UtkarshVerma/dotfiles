local util = require("lazy.core.util")

---@class util
local M = {
  colors = require("util.colors"),
  fs = require("util.fs"),
  log = require("util.log"),
  plugin = require("util.plugin"),
  terminal = require("util.terminal"),
  toggle = require("util.toggle"),
  ui = require("util.ui"),

  merge = util.merge,
}

---Get the pretty-print form of the stack-trace.
---@return string
---@nodiscard
local function pretty_trace()
  local Config = require("lazy.core.config")
  local trace = {}
  local level = 2

  while true do
    local info = debug.getinfo(level, "Sln")
    if not info then
      break
    end

    if info.what ~= "C" and (Config.options.debug or not info.source:find("lazy.nvim")) then
      local source = info.source:sub(2)
      if source:find(Config.options.root, 1, true) == 1 then
        source = source:sub(#Config.options.root + 1)
      end

      source = vim.fn.fnamemodify(source, ":p:~:.")
      local line = string.format(" - %s:%s", source, info.currentline)
      if info.name then
        line = string.format("%s _in_ **%s**", line, info.name)
      end

      table.insert(trace, line)
    end

    level = level + 1
  end

  return #trace > 0 and ("\n\n# stacktrace:\n" .. table.concat(trace, "\n")) or ""
end

---Try executing {fn} and log {message} if it fails.
---@generic T
---@param fn fun():T?
---@param message string
---@return T?
function M.try(fn, message)
  local error_handler = function(err)
    message = (message .. "\n\n") .. err .. pretty_trace()

    vim.schedule(function()
      M.log.error(message)
    end)

    return err
  end

  local ok, result = xpcall(fn, error_handler)
  return ok and result or nil
end

---Execute a {callback} on the `VeryLazy` event.
---@param callback fun()
function M.on_very_lazy(callback)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = callback,
  })
end

---Delay notifications till `vim.notify` is replaced or after 500 ms, whichever is earlier.
function M.lazy_notify()
  local notifications = {}
  local function temp(...)
    table.insert(notifications, vim.F.pack_len(...))
  end

  local original = vim.notify
  vim.notify = temp

  local timer = assert(vim.uv.new_timer())
  local check = assert(vim.uv.new_check())

  local replay = function()
    timer:stop()
    check:stop()

    -- Put back the original notify function.
    if vim.notify == temp then
      vim.notify = original
    end

    -- Display all queued notifications.
    vim.schedule(function()
      for _, notification in ipairs(notifications) do
        vim.notify(vim.F.unpack_len(notification))
      end
    end)
  end

  -- Wait till `vim.notify` has been replaced.
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)

  -- After 500 ms, replay notifications anyway as something might have failed.
  timer:start(500, 0, replay)
end

---Get up value for {func}'s {name} variable.
---@generic T
---@param func fun(...):T
---@param name string
---@return unknown?
---@nodiscard
function M.get_upvalue(func, name)
  local i = 1

  while true do
    local n, v = debug.getupvalue(func, i)
    if n == nil then
      return nil
    end

    if n == name then
      return v
    end

    i = i + 1
  end
end

---Check if buffer contains a large file.
---@return boolean
---@nodiscard
function M.buf_has_large_file(bufnr)
  local max_size = 100 * 1024 -- 100 KiB.
  local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))

  if ok and stats and stats.size > max_size then
    return true
  end

  return false
end

---Remove duplicates from list.
---@generic T
---@param list T[]
---@return T[]
---@nodiscard
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end

  return ret
end

return M
