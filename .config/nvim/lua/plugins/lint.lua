---@class plugins.lint.linter
---@field prepend_args? string[]

---@class plugins.lint.config
---@field linters? table<string, plugins.lint.linter>
---@field linters_by_ft? table<string, string[]>

local util = require("util")

-- Override `{default_linters}` with `{linters}` in-place.
---@param default_linters lint.Linter[]
---@param linters plugins.lint.linter
local function override_linters(default_linters, linters)
  for name, linter in pairs(linters) do
    local default_linter = default_linters[name]

    if type(default_linter) == "table" then
      default_linter = vim.tbl_deep_extend("force", default_linter, linter)

      if linter.prepend_args ~= nil then
        vim.list_extend(linter.prepend_args, default_linter.args)
        default_linter.args = vim.deepcopy(linter.prepend_args)
        linter.prepend_args = nil
      end
    end

    default_linters[name] = default_linter
  end
end

---@type LazyPluginSpec[]
return {
  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    init = function()
      -- Register the nvim-lint linter on VeryLazy.
      util.on_very_lazy(function()
        util.lint.register({
          name = "nvim-lint",
          priority = 100,
          lint = function(_)
            require("lint").try_lint()
          end,
          sources = function(bufnr)
            local linters = require("lint")._resolve_linter_by_ft(vim.bo[bufnr].filetype)

            return linters
          end,
        })
      end)
    end,
    ---@type plugins.lint.config
    opts = {
      linters_by_ft = {},
      linters = {},
    },
    config = function(_, opts)
      local lint = require("lint")
      override_linters(lint.linters, opts.linters)
      lint.linters_by_ft = opts.linters_by_ft
    end,
  },

  {
    "mason.nvim",
    opts = function(_, opts)
      local renames = {
        biomejs = "biome",
      }

      local linters = vim.tbl_flatten(vim.tbl_values(util.plugin.opts("nvim-lint").linters_by_ft))
      for i, linter in pairs(linters) do
        if renames[linter] then
          linters[i] = renames[linter]
        end
      end

      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, linters)
      table.sort(opts.ensure_installed)

      opts.ensure_installed = vim.fn.uniq(opts.ensure_installed)
    end,
  },
}
