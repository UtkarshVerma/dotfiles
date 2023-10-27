local util = require("util")

---@class config
local M = {
  icons = require("config.icons"),
  logo = require("config.logo"),
  json = require("config.json"),
  kind_filter = require("config.kind-filter"),
}

function M.setup()
  -- autocmds can be loaded lazily when not opening a file
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    M.load("autocmds")
  end

  local group = vim.api.nvim_create_augroup("Editor", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        M.load("autocmds")
      end

      M.load("keymaps")

      util.format.setup()
      util.news.setup()
      util.root.setup()

      vim.api.nvim_create_user_command("Extras", function()
        util.extras.show()
      end, { desc = "Manage extras" })
    end,
  })
end

---@param name "autocmds" | "options" | "keymaps"
function M.load(name)
  local function _load(mod)
    if require("lazy.core.cache").find(mod)[1] then
      util.try(function()
        require(mod)
      end, { msg = "Failed loading " .. mod })
    end
  end

  _load("config." .. name)
  if vim.bo.filetype == "lazy" then
    -- HACK: Editor may have overwritten options of the Lazy UI, so reset this here
    vim.cmd([[do VimResized]])
  end
  local pattern = "Editor" .. name:sub(1, 1):upper() .. name:sub(2)
  vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

M.did_init = false
function M.init()
  if M.did_init then
    return
  end

  M.did_init = true

  -- delay notifications till vim.notify was replaced or after 500ms
  util.lazy_notify()

  -- load options here, before lazy init while sourcing plugin modules
  -- this is needed to make sure options will be correctly applied
  -- after installing missing plugins
  M.load("options")

  util.plugin.setup()
  M.json.load()
end

return M
