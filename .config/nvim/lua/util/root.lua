---@class util.root.root
---@field paths string[]
---@field spec util.root.spec

---@alias util.root.spec string|string[]
---@alias util.root.detector fun(bufnr:integer, spec:util.root.spec):string[]

---@class util.root
---@field specs util.root.spec[]
local M = {}

---@type table<integer, string>
local root_dir_cache = {}

---@type table<string, util.root.detector>
local detectors = {
  -- Get the current working directory.
  ---@nodiscard
  cwd = function(_, _)
    local cwd = require("util").fs.cwd()
    return cwd and { cwd } or {}
  end,

  -- Query the LSP for the root directory.
  ---@nodiscard
  lsp = function(_, _)
    return vim.tbl_values(vim.lsp.buf.list_workspace_folders())
  end,

  -- Get the root directory for buffer {bufnr} based on file patterns passed as {spec}.
  ---@nodiscard
  pattern = function(bufnr, spec)
    local util = require("util")
    local patterns = type(spec) == "string" and { spec } or spec

    local path = util.fs.normalize_path(vim.api.nvim_buf_get_name(bufnr)) or util.fs.cwd()
    local pattern = vim.fs.find(patterns, { path = path, upward = true })[1]

    return pattern and { vim.fs.dirname(pattern) } or {}
  end,
}

-- Detect root directories for {opts.bufnr} based on {opts.spec}.
---@param opts? {bufnr?: integer, all?: boolean}
---@return util.root.root[]
---@nodiscard
local function detect(opts)
  local util = require("util")

  opts = opts or {}
  local all = opts.all or false
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  local roots = {} ---@type util.root.root[]
  for _, spec in ipairs(M.specs) do
    local detector = detectors[type(spec) == "string" and spec or "pattern"]

    local paths = detector(bufnr, spec)
    paths = vim.tbl_map(util.fs.normalize_path, paths) --[=[@as string[]]=]

    -- Sort paths based in increasing order of length.
    table.sort(paths, function(a, b)
      return #a > #b
    end)

    if #paths > 0 then
      roots[#roots + 1] = { spec = spec, paths = paths }

      if not all then
        break
      end
    end
  end

  return roots
end

-- Display detected root directories.
local function show_roots()
  local util = require("util")

  local roots = detect({ all = true })
  local lines = { "" }
  local first = true
  for _, root in ipairs(roots) do
    for _, path in ipairs(root.paths) do
      local s = type(root.spec) == "table" and table.concat(root.spec --[[@as table]], ", ") or root.spec

      lines[#lines + 1] = string.format("- [%s] `%s` **(%s)**", first and "x" or " ", path, s)
      first = false
    end
  end

  util.log.info(table.concat(lines, "\n"), "Roots")
end

-- Get the root directory for {opts.bufnr} based on:
-- - LSP workspace folders
-- - LSP root directory
-- - Root pattern of current buffer's filename
-- - Root pattern of the current working directory
---@param opts? {bufnr?: integer}
---@return string
---@nodiscard
function M.dir(opts)
  local util = require("util")
  opts = opts or {}

  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local root = root_dir_cache[bufnr]

  if root == nil then
    local roots = detect({ all = false })
    root = roots[1] and roots[1].paths[1] or util.fs.cwd()
    root_dir_cache[bufnr] = root
  end

  return root
end

---@param opts? {specs?: util.root.spec[]}
function M.setup(opts)
  opts = opts or {}
  M.specs = opts.specs or { "lsp", { ".git", "lua" }, "cwd" }

  vim.api.nvim_create_user_command("Root", show_roots, { desc = "Roots for the current buffer" })

  vim.api.nvim_create_autocmd("BufDelete", {
    desc = "Reset root cache on buffer delete",
    callback = function(arg)
      root_dir_cache[arg.buf] = nil
    end,
  })
end

return M
