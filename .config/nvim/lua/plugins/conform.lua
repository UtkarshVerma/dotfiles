local util = require("util")

---@type ConformOpts
local conform_opts = {}

---@type LazyPluginSpec[]
return {
  {
    "stevearc/conform.nvim",
    cmd = "ConformInfo",
    keys = {
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
      -- Register the conform formatter on VeryLazy.
      util.on_very_lazy(function()
        util.format.register({
          name = "conform.nvim",
          priority = 100,
          format = function(bufnr)
            require("conform").format({
              timeout_ms = conform_opts.format.timeout_ms,
              async = conform_opts.format.async,
              quiet = conform_opts.format.quiet,
              bufnr = bufnr,
            })
          end,
          sources = function(bufnr)
            local ret = require("conform").list_formatters(bufnr)

            ---@param v conform.FormatterInfo
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        })
      end)
    end,
    ---@class ConformOpts
    opts = {
      format = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
      },
      ---@type table<string, conform.FormatterUnit[]>
      formatters_by_ft = {},
      -- The options you set here will be merged with the builtin formatters.
      -- You can also define any custom formatters here.
      ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): conform.FormatterConfigOverride?>
      formatters = {
        injected = { options = { ignore_errors = true } },
        -- # Example of using dprint only when a dprint.json file is present
        -- dprint = {
        --   condition = function(ctx)
        --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
      },
    },
    config = function(_, opts)
      conform_opts = opts
      require("conform").setup(opts)
    end,
  },

  {
    "mason.nvim",
    opts = function(_, opts)
      local renames = {
        biomejs = "biome",
      }

      local formatters = vim.tbl_flatten(vim.tbl_values(util.plugin.opts("conform.nvim").formatters_by_ft))
      for i, formatter in pairs(formatters) do
        if renames[formatter] then
          formatters[i] = renames[formatter]
        end
      end

      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, formatters)
      table.sort(opts.ensure_installed)

      opts.ensure_installed = vim.fn.uniq(opts.ensure_installed)
    end,
  },
}
