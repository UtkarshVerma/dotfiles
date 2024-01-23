---@class util.terminal
local M = {}

---@type table<string,LazyFloat>
local terminals = {}

---@class util.terminal.opts: LazyCmdOptions
---@field interactive? boolean
---@field esc_esc? boolean
---@field ctrl_hjkl? boolean

-- Opens a floating terminal with command {cmd}.
---@param cmd? string[]|string
---@param opts? util.terminal.opts
function M.open(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    ft = "lazyterm",
    size = { width = 0.9, height = 0.9 },
  }, opts or {}, { persistent = true }) --[[@as util.terminal.opts]]

  local termkey = vim.inspect({ cmd = cmd or "shell", cwd = opts.cwd, env = opts.env, count = vim.v.count1 })

  if terminals[termkey] and terminals[termkey]:buf_valid() then
    terminals[termkey]:toggle()
    return
  end

  terminals[termkey] = require("lazy.util").float_term(cmd, opts)
  local buf = terminals[termkey].buf
  vim.b[buf].lazyterm_cmd = cmd
  if opts.esc_esc == false then
    vim.keymap.set("t", "<esc>", "<esc>", { buffer = buf, nowait = true })
  end

  if opts.ctrl_hjkl == false then
    vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = buf, nowait = true })
    vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = buf, nowait = true })
    vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = buf, nowait = true })
    vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = buf, nowait = true })
  end

  local util = require("util")
  util.create_autocmd("BufEnter", {
    buffer = buf,
    callback = function()
      vim.cmd.startinsert()
    end,
  })
end

return M
