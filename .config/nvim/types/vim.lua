---@meta

---@alias vim.autocommand.event string|string[]

---@class vim.autocommand.callback.arg
---@field id number
---@field event string
---@field group? number
---@field match string
---@field buf number
---@field file string
---@field data table

---@alias vim.autocommand.callback fun(arg:vim.autocommand.callback.arg):boolean?

---@class vim.autocommand.opts
---@field group? integer
---@field desc? string
---@field command? string
---@field buffer? integer
---@field pattern? string|string[]
---@field callback? vim.autocommand.callback

---@param event vim.autocommand.event
---@param opts vim.autocommand.opts
---@return integer
function vim.api.nvim_create_autocmd(event, opts) end

---@generic T
---@param dst T[]
---@param src T[]
---@param start? integer
---@param finish? integer
function vim.list_extend(dst, src, start, finish) end
