return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {},
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
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

  {
    "indent-blankline.nvim",
    opts = function(_, opts)
      vim.tbl_deep_extend("force", opts, {
        exclude = {
          filetypes = vim.list_extend(vim.tbl_get(opts, "exclude", "filetypes") or {}, { "mason" }),
        },
      })
    end,
  },

  {
    "nvim-scrollview",
    opts = function(_, opts)
      opts.excluded_filetypes = vim.list_extend(opts.excluded_filetypes or {}, { "mason" })
    end,
  },
}
