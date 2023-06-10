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
-- end

function M.load(name)
  local ok, err = pcall(require, "config." .. name)
  if not ok then
    vim.notify("Error loading " .. name .. ": " .. err, vim.log.levels.ERROR)
  end
end

M.icons = require("config.icons")

return M
