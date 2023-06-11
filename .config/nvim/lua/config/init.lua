local M = {}

function M.setup()
  M.load("options")

  -- if vim.fn.argc(-1) == 0 then
  --   -- autocmds and keymaps can wait to load
  --   vim.api.nvim_create_autocmd("User", {
  --     group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
  --     pattern = "VeryLazy",
  --     callback = function()
  --       M.load("autocmds")
  --       M.load("keymaps")
  --     end,
  --   })
  -- else
  -- load them now so they affect the opened buffers

  M.load("autocmds")
  M.load("keymaps")
end

function M.load(name)
  local Util = require("lazy.core.util")
  local function _load(mod)
    Util.try(function()
      require(mod)
    end, {
      msg = "Failed loading " .. mod,
      on_error = function(msg)
        local info = require("lazy.core.cache").find(mod)
        if info == nil or (type(info) == "table" and #info == 0) then
          return
        end
        Util.error(msg)
      end,
    })
  end
  _load("config." .. name)
end

M.icons = require("config.icons")

return M
