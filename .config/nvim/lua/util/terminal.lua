---@class util.terminal
local M = {}

---@type table<string, LazyFloat>
local terminals = {}

---@class util.terminal.opts: LazyCmdOptions
---@field interactive? boolean
---@field esc_esc? boolean
---@field ctrl_hjkl? boolean

-- Opens a floating terminal with command {cmd}.
---@param cmd? string[]|string
---@param opts? util.terminal.opts
function M.open(cmd, opts)
  opts = vim.tbl_extend("force", {
    ft = "lazyterm",
    size = { width = 0.9, height = 0.9 },
    persistent = true,
    esc_esc = true,
    ctrl_hjkl = true,
  }, opts or {})

  local termkey = vim.inspect({ cmd = cmd or "shell", cwd = opts.cwd, env = opts.env, count = vim.v.count1 })
  if terminals[termkey] and terminals[termkey]:buf_valid() then
    terminals[termkey]:toggle()
    return
  end

  terminals[termkey] = require("lazy.util").float_term(cmd, opts)
  local buf = terminals[termkey].buf
  vim.b[buf].lazyterm_cmd = cmd
  if not opts.esc_esc then
    vim.keymap.set("t", "<esc>", "<esc>", { buffer = buf, nowait = true })
  end

  if not opts.ctrl_hjkl then
    vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = buf, nowait = true })
    vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = buf, nowait = true })
    vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = buf, nowait = true })
    vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = buf, nowait = true })
  end

  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = buf,
    callback = function()
      vim.cmd.startinsert()
    end,
  })
end

return M
