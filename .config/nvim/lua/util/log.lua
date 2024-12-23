---@class util.log
local M = {}

---Dispatch a notification with message {message}.
---@param message string
---@param opts? {title?: string, once?: boolean, level?: integer, replace?: string, lang?: string}
local function notify(message, opts)
  opts = opts or {}
  local lang = opts.lang or "markdown"
  local notify_func = opts.once and vim.notify_once or vim.notify
  local level = opts.level or vim.log.levels.INFO

  notify_func(message, level, {
    title = opts.title or "Editor",
    on_open = function(win)
      local ok = pcall(function()
        vim.treesitter.language.add(lang)
      end)

      if not ok then
        pcall(require, "nvim-treesitter")
      end

      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = ""
      vim.wo[win].spell = false
      local buf = vim.api.nvim_win_get_buf(win)
      if not pcall(vim.treesitter.start, buf, lang) then
        vim.bo[buf].filetype = lang
        vim.bo[buf].syntax = lang
      end
    end,
  })
end

---Log {message} as information.
---@param message string
---@param title? string
function M.info(message, title)
  notify(message, { title = title, level = vim.log.levels.INFO })
end

---Log {message} as a warning.
---@param message string
---@param title? string
function M.warn(message, title)
  notify(message, { title = title, level = vim.log.levels.WARN })
end

---Log {message} as an error.
---@param message string
---@param title? string
function M.error(message, title)
  notify(message, { title = title, level = vim.log.levels.ERROR })
end

return M
