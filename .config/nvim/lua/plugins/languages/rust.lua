---@module "rustaceanvim"
---@class plugins.crates.config: crates.UserConfig

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "ron",
        "rust",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.taplo.config
        ---@diagnostic disable-next-line: missing-fields
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                else
                  require("crates").show_popup()
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show crate documentation",
            },
          },
        },
      },
    },
  },

  {
    "mason.nvim",
    ---@type plugins.mason.config
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "codelldb",
      },
    },
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    tag = "stable",
    ---@type plugins.crates.config
    opts = {
      completion = {
        crates = {
          enabled = false,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false, -- It's lazy by default.
    dependencies = {
      "nvim-dap",
    },
    init = function(_)
      vim.g.rustaceanvim = {
        ---@type rustaceanvim.lsp.ClientOpts
        server = {
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<leader>dR", function()
              vim.cmd.RustLsp("debuggables")
              ---@diagnostic disable-next-line: missing-fields
            end, { desc = "Debuggables (Rust)", buffer = bufnr })
          end,
        },
      }
    end,
  },

  {
    "neotest",
    ---@type plugins.neotest.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      adapters = {
        ["rustaceanvim.neotest"] = {},
      },
    },
  },
}
