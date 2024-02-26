local util = require("util")

---@class config
local M = {
  icons = require("config.icons"),
  logo = require("config.logo"),
}

-- Initialize the editor.
function M.init()
  util.lazy_notify()

  M.load("options")
  util.plugin.setup()
end

-- Set up the editor.
function M.setup()
  -- Autocmds can be loaded lazily when not opening a file.
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load("autocmds")
  end

  local group = vim.api.nvim_create_augroup("Editor", {})
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        M.load("autocmds")
      end

      M.load("keymaps")
      util.root.setup()
    end,
  })
end

-- Load configuration for {name}.
---@param name "autocmds"|"options"|"keymaps"
function M.load(name)
  local mod = "config." .. name
  if require("lazy.core.cache").find(mod)[1] then
    util.try(function()
      require(mod)
    end, "Failed loading " .. mod)
  end

  if vim.bo.filetype == "lazy" then
    -- HACK: Editor may have overwritten options of the Lazy UI, so reset this here
    vim.cmd([[do VimResized]])
  end
end

return M
