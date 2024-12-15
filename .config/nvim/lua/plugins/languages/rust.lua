---@module "rustaceanvim"

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
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
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
    "nvim-cmp",
    ---@param opts plugins.cmp.config
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "crates" })
    end,
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
    opts = {
      completion = {
        cmp = { enabled = true },
      },
    },
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false, -- It's lazy by default.
    init = function(_)
      vim.g.rustaceanvim = {
        ---@type rustaceanvim.lsp.ClientOpts
        server = {
          on_attach = function(_, bufnr)
            -- Use rust-analyzer's code action grouping.
            vim.keymap.set("n", "<leader>ca", function()
              vim.cmd.RustLsp("codeAction")
            end, { desc = "Code action", buffer = bufnr })

            vim.keymap.set("n", "<leader>dR", function()
              vim.cmd.RustLsp("debuggables")
            end, { desc = "Rust debuggables", buffer = bufnr })
          end,
          default_settings = {
            ["rust-analyzer"] = {},
          },
        },
        dap = {},
      }
    end,
  },

  {
    "neotest",
    opts = {
      adapters = {
        ["rustaceanvim.neotest"] = {},
      },
    },
  },
}
