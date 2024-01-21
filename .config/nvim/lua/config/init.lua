local util = require("util")

---@class config
local M = {
  icons = require("config.icons"),
  logo = require("config.logo"),
  kind_filter = require("config.kind-filter"),
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
  util.create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        M.load("autocmds")
      end

      M.load("keymaps")

      util.format.setup()
      util.root.setup()
    end,
  })
end

-- Load configuration for {name}.
---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local function load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      util.try(function()
        require(mod)
      end, "Failed loading " .. mod)
    end
  end

  load("config." .. name)
  if vim.bo.filetype == "lazy" then
    -- HACK: Editor may have overwritten options of the Lazy UI, so reset this here
    vim.cmd([[do VimResized]])
  end

  -- TODO: Does this work?
  local pattern = "Editor" .. name:sub(1, 1):upper() .. name:sub(2)
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

return M
