---@class plugins.conform.config.format_on_save
---@field lsp_fallback? boolean
---@field timeout_ms? integer

---@class plugins.conform.config
---@field notify_on_error? boolean
---@field format_on_save? plugins.conform.config.format_on_save|fun(bufnr:integer):plugins.conform.config.format_on_save?
---@field formatters? table<string, conform.FormatterConfigOverride|fun(bufnr:integer):conform.FormatterConfigOverride>
---@field formatters_by_ft? table<string, conform.FormatterUnit[]>

local util = require("util")

-- Check if buffer {bufnr} can be formatted.
---@param bufnr integer
---@return boolean
---@nodiscard
local function can_format(bufnr)
  local buffer_autoformat = vim.b[bufnr].autoformat --[[@as boolean?]]
  local global_autoformat = vim.g.autoformat --[[@as boolean]]

  if buffer_autoformat ~= nil then
    return buffer_autoformat
  end

  return global_autoformat
end

-- Display autoformat status for buffer {bufnr}.
---@param bufnr? integer
local function show_status(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local enabled = can_format(bufnr)
  local buffer_autoformat = vim.b[bufnr].autoformat --[[@as boolean?]]

  local lines = {
    (enabled and "enabled" or "disabled"),
    string.format("- [%s] global", vim.g.autoformat and "x" or " "),
    string.format(
      "- [%s] buffer%s",
      (buffer_autoformat or enabled) and "x" or " ",
      buffer_autoformat == nil and " (inherit)" or ""
    ),
  }

  local message = table.concat(lines, "\n")
  local title = "Format"
  if enabled then
    util.log.info(message, title)
  else
    util.log.warn(message, title)
  end
end

-- Toggle formatting for {mode}.
---@param mode "buffer"|"global"
local function toggle_autoformat(mode)
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = can_format(bufnr)

  if mode == "buffer" then
    vim.b[bufnr].autoformat = not enabled
  else
    vim.g.autoformat = not enabled
    vim.b[bufnr].autoformat = nil
  end

  show_status(bufnr)
end

---@type LazyPluginSpec[]
return {
  {
    "mason.nvim",
    ---@return plugins.mason.config
    opts = function(_, opts)
      local renames = {
        biomejs = "biome",
        nixpkgs_fmt = "nixpkgs-fmt",
      }

      local conform_opts = util.plugin.opts("conform.nvim") --[[@as plugins.conform.config]]
      local formatters = vim
        .iter(vim.tbl_values(conform_opts.formatters_by_ft))
        :flatten()
        :map(function(formatter)
          return renames[formatter] or formatter
        end)
        :totable()

      return vim.tbl_deep_extend("force", opts, {
        ensure_installed = vim.list_extend(opts.ensure_installed or {}, formatters),
      })
    end,
  },

  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    event = "LazyFile",
    cmd = "ConformInfo",
    keys = {
      { "<leader>uC", "<cmd>ConformInfo<cr>", desc = "Conform information" },
      -- stylua: ignore start
      { "<leader>tf", function() toggle_autoformat("global") end, desc = "Auto-format (global)" },
      { "<leader>tF", function() toggle_autoformat("buffer") end, desc = "Auto-format (buffer)" },
      -- stylua: ignore end
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" } })
        end,
        mode = { "n", "v" },
        desc = "Format injected languages",
      },
    },
    init = function()
      vim.g.autoformat = true
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    ---@type plugins.conform.config
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        if not can_format(bufnr) then
          return nil
        end

        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {},
      formatters = {},
    },
  },
}
