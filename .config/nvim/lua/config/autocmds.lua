---@alias config.autocommand {[1]: vim.autocommand.event, [2]: vim.autocommand.callback|string}|vim.autocommand.opts

---@type config.autocommand[]
local autocommands = {
  {
    { "FocusGained", "TermClose", "TermLeave" },
    "checktime",
    desc = "Reload file if it was modified in the background",
  },

  -- stylua: ignore
  { "TextYankPost", function(_) vim.highlight.on_yank() end, desc = "Highlight on yank" },

  {
    "VimResized",
    function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd("tabdo wincmd =")
      vim.cmd("tabnext " .. current_tab)
    end,
    desc = "Resize splits on window resize",
  },

  {
    "BufReadPost",
    function(arg)
      local exclude = { "gitcommit" }
      local buf = arg.buf
      if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
        return
      end

      vim.b[buf].last_loc = true
      local mark = vim.api.nvim_buf_get_mark(buf, '"')
      local lcount = vim.api.nvim_buf_line_count(buf)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
    desc = "Go to last line of code when opening a buffer",
  },

  {
    "FileType",
    function(_)
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end,
    desc = "Wrap and check for spell in text files",
    pattern = { "gitcommit", "markdown" },
  },

  {
    "BufWritePre",
    function(arg)
      if arg.match:match("^%w%w+://") then
        return
      end

      local file = vim.loop.fs_realpath(arg.match) or arg.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
    desc = "Auto create parent directories when they don't exist",
  },

  {
    "VimLeave",
    command = "set guicursor= | call chansend(v:stderr, '\x1b[ q')",
    desc = "Restore default cursor on exit",
  },

  {
    "FileType",
    function(arg)
      vim.bo[arg.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = arg.buf })
    end,
    pattern = {
      "help",
      "man",
      "notify",
      "qf",
      "query",
      "spectre_panel",
      "checkhealth",
    },
    desc = "Close with q",
  },

  {
    { "BufNewFile", "BufRead" },
    'setlocal noswapfile nobackup noundofile shada=""',
    pattern = "/dev/shm/gopass*",
    desc = "Do not cache data for gopass secrets",
  },
}

for _, autocommand in ipairs(autocommands) do
  local event = autocommand[1]
  local callback = autocommand[2]
  autocommand[1] = nil
  autocommand[2] = nil

  ---@type vim.autocommand.opts
  local opts = autocommand
  opts[type(callback) == "string" and "command" or "callback"] = callback

  vim.api.nvim_create_autocmd(event, opts)
end
