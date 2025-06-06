---@class util.plugin
local M = {}

---Check if {plugin} exists in the spec.
---@param plugin string
---@return boolean
---@nodiscard
function M.exists(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---Get options for plugin {name}.
---@param name string
---@return table?
---@nodiscard
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if plugin == nil then
    return nil
  end

  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---Execute {callback} after plugin {name} is loaded.
---@param name string
---@param callback fun(name:string)
function M.on_load(name, callback)
  local config = require("lazy.core.config")
  if config.plugins[name] and config.plugins[name]._.loaded then
    callback(name)
    return
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(arg)
      if arg.data == name then
        callback(name)

        -- Delete the autocommand.
        return true
      end
    end,
  })
end

---Check if {plugin} is loaded.
---@param plugin string
---@return boolean
---@nodiscard
function M.is_loaded(plugin)
  local Config = require("lazy.core.config")
  return Config.plugins[plugin] and Config.plugins[plugin]._.loaded ~= nil
end

function M.setup()
  -- Set up the `LazyFile` event.
  local event = require("lazy.core.handler.event")
  event.mappings["LazyFile"] = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
  event.mappings["User LazyFile"] = event.mappings.LazyFile
end

return M
