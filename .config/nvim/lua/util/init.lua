local util = require("lazy.core.util")

---@class util
local M = {
  format = require("util.format"),
  plugin = require("util.plugin"),
  root = require("util.root"),
  lsp = require("util.lsp"),
  news = require("util.news"),
  json = require("util.json"),
  inject = require("util.inject"),
  ui = require("util.ui"),
  telescope = require("util.telescope"),
  terminal = require("util.terminal"),
  toggle = require("util.toggle"),
  extras = require("util.extras"),

  track = util.track,
  try = util.try,
  info = util.info,
  warn = util.warn,
  error = util.error,
  norm = util.norm,
  merge = util.merge,
  is_list = util.is_list,
  find_root = util.find_root,
  walk = util.walk,
}

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function M.is_win()
  return vim.loop.os_uname().sysname:find("Windows") ~= nil
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = assert(vim.loop.new_check())

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  local config = require("lazy.core.config")
  if config.plugins[name] and config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

return M
