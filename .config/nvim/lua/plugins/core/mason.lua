---@class plugins.mason.config: MasonSettings
---@field ensure_installed? string[]

local util = require("util")

---@type LazyPluginSpec[]
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = {
      { "<leader>um", "<cmd>Mason<cr>", desc = "Mason" },
    },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    ---@type plugins.mason.config
    opts = {
      ensure_installed = {},
    },
    ---@param opts plugins.mason.config
    config = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        opts.ensure_installed = util.dedup(opts.ensure_installed)
      end

      require("mason").setup(opts)

      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- Trigger `FileType` event to possibly load this newly installed LSP server.
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
}
