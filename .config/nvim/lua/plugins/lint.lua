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
    "mason.nvim",
    ---@param opts plugins.mason.config
    opts = function(_, opts)
      local renames = {
        biomejs = "biome",
      }

      local linters = vim.tbl_map(function(linter)
        return renames[linter] or linter
      end, vim.tbl_flatten(vim.tbl_values(util.plugin.opts("nvim-lint").linters_by_ft)))

      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, linters)
    end,
  },

  {
    "mfussenegger/nvim-lint",
    event = "LazyFile",
    dependencies = { "mason.nvim" },
    init = function(_)
      util.create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
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
}
