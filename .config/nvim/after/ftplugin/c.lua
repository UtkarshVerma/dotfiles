local fs = require("util.fs")

---Walk upwards from a directory to find `.clang-format`.
---@param dir string
---@return string? path Full path to the .clang-format, or nil if not found.
local function find_clang_format(dir)
  ---@diagnostic disable-next-line: redefined-local
  local dir = fs.normalize(dir)

  while dir do
    local candidate = dir .. "/.clang-format"
    local stat = vim.uv.fs_stat(candidate)
    if stat and stat.type == "file" then
      return candidate
    end

    --- @type string?
    local parent = dir:match("^(.*)/[^/]+$")
    if not parent or parent == dir then
      break
    end
    dir = parent
  end

  return nil
end

---Extract ColumnLimit value from a .clang-format file.
---@param path string Path to .clang-format file.
---@return string? limit The number if found, else nil.
local function get_column_limit(path)
  local f = io.open(path, "r")
  if not f then
    return nil
  end

  for line in f:lines() do
    local value = line:match("^%s*ColumnLimit:%s*(%d+)")
    if value then
      f:close()
      return value
    end
  end
  f:close()

  return nil
end

--- Apply the column limit to the current buffer's colorcolumn.
local function apply_columnlimit()
  if vim.t.clang_format_limit then
    vim.opt_local.colorcolumn = vim.t.clang_format_limit
    vim.wo.colorcolumn = vim.t.clang_format_limit
  end
end

--- Apply clang-format's ColumnLimit setting to colorcolumn.
local bufdir = vim.fn.expand("%:p:h")
local clang_format_path = find_clang_format(bufdir)
if clang_format_path then
  -- Set the column limit for the first time if it hasn't been set yet.
  if not vim.t.clang_format_limit then
    vim.t.clang_format_limit = get_column_limit(clang_format_path)
  end
  apply_columnlimit()

  local watcher = vim.uv.new_fs_event()
  if not watcher then
    vim.notify("Failed to create fs_event watcher for .clang-format", vim.log.levels.ERROR)
    return
  end

  local timer = vim.uv.new_timer()

  ---Watch the .clang-format file for changes.
  local function watch_file()
    watcher:start(
      clang_format_path,
      {},

      ---@param events uv.aliases.fs_event_start_callback_events
      vim.schedule_wrap(function(err, filename)
        if err then
          vim.notify("Error watching .clang-format: " .. err, vim.log.levels.ERROR)
          return
        end

        vim.t.clang_format_limit = get_column_limit(filename)
        apply_columnlimit()

        -- The file update can trigger rename and changed event both for a single change, so debounce here.
        watcher:stop()
        timer:start(100, 0, vim.schedule_wrap(watch_file))
      end)
    )
  end

  watch_file()
end
