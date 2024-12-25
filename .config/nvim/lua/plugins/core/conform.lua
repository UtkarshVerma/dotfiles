---@class plugins.conform.config.format_on_save
---@field lsp_fallback? boolean
---@field timeout_ms? integer

---@class plugins.conform.config: conform.setupOpts

local util = require("util")

---Check if buffer {bufnr} can be formatted.
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

---Display autoformat status for buffer {bufnr}.
---@param bufnr? integer
local function show_status(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local enabled = can_format(bufnr)
  local buffer_autoformat = vim.b[bufnr].autoformat --[[@as boolean?]]

  local message = string.format(
    "%s: buffer (%s%s), global (%s)",
    (enabled and "Enabled" or "Disabled"),
    (buffer_autoformat or enabled) and "yes" or "no",
    buffer_autoformat == nil and ", inherited" or "",
    vim.g.autoformat and "yes" or "no"
  )

  local title = "Format"
  if enabled then
    util.log.info(message, title)
  else
    util.log.warn(message, title)
  end
end

---Toggle formatting for {mode}.
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
        cmake_format = "cmakelang",
        nixpkgs_fmt = "nixpkgs-fmt",
        terraform_fmt = "",
        packer_fmt = "",
        typstyle = "", -- TODO: Wait for https://github.com/mason-org/mason-registry/issues/8015
        injected = "",
      }

      local conform_opts = util.plugin.opts("conform.nvim") --[[@as plugins.conform.config]]
      local formatters = vim
        .iter(vim.tbl_values(conform_opts.formatters_by_ft))
        :flatten()
        :map(function(formatter)
          local rename = renames[formatter]
          if rename == "" then
            return nil
          end

          return rename or formatter
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
      { "<leader>tf", function() toggle_autoformat("buffer") end, desc = "Auto-format (buffer)" },
      { "<leader>tF", function() toggle_autoformat("global") end, desc = "Auto-format (global)" },
      -- stylua: ignore end
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

        ---@type conform.FormatOpts
        return { timeout_ms = 500, lsp_fallback = true }
      end,
      formatters_by_ft = {},
      formatters = {},
    },
  },
}
