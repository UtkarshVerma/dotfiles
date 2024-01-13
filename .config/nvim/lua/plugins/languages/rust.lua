local util = require("util")

return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "ron",
        "rust",
        "toml",
      })
    end,
  },

  {
    "simrat39/rust-tools.nvim",
    dependencies = { "mason.nvim" },
    opts = function()
      -- rust tools configuration for debugging support
      local codelldb = require("mason-registry").get_package("codelldb")
      local extension_path = codelldb:get_install_path() .. "/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = ""
      if vim.loop.os_uname().sysname:find("Windows") then
        liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
      elseif vim.fn.has("mac") == 1 then
        liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
      else
        liblldb_path = extension_path .. "lldb/lib/liblldb.so"
      end
      local adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)

      local inlay_hints_prefixes = {
        parameter_hints_prefix = "<- ",
        other_hints_prefix = "=> ",
      }
      local is_newline_shown = vim.opt.list:get() and vim.opt.listchars:get()["eol"]
      if is_newline_shown then
        for k, v in pairs(inlay_hints_prefixes) do
          inlay_hints_prefixes[k] = " " .. v
        end
      end

      return {
        dap = {
          adapter = adapter,
        },
        tools = {
          on_initialized = function()
            local autocmds = {
              { events = "CursorHold", callback = vim.lsp.buf.document_highlight },
              { events = { "CursorMoved", "InsertEnter" }, callback = vim.lsp.buf.clear_references },
              { events = { "BufEnter", "CursorHold", "InsertLeave" }, callback = vim.lsp.codelens.refresh },
            }

            local group = vim.api.nvim_create_augroup("rust_lsp", { clear = true })
            for _, autocmd in pairs(autocmds) do
              vim.api.nvim_create_autocmd(autocmd.events, {
                group = group,
                pattern = "*.rs",
                callback = autocmd.callback,
              })
            end
          end,
          inlay_hints = inlay_hints_prefixes,
          hover_actions = { border = util.ui.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l") },
        },
      }
    end,
    config = false,
  },

  {
    "Saecki/crates.nvim",
    tag = "stable",
    dependencies = { "plenary.nvim" },
    event = { "BufRead Cargo.toml" },
    opts = {
      src = {
        cmp = { enabled = true },
      },
    },
  },

  {
    "nvim-lspconfig",
    dependencies = {
      "crates.nvim",
    },
    opts = {
      servers = {
        -- rust_analyzer = {
        --   keys = {
        --     { "K", "<cmd>RustHoverActions<cr>", desc = "Hover actions (Rust)" },
        --     { "<leader>cR", "<cmd>RustCodeAction<cr>", desc = "Code action (Rust)" },
        --     { "<leader>dr", "<cmd>RustDebuggables<cr>", desc = "Run debuggables (Rust)" },
        --   },
        --   settings = {
        --     ["rust-analyzer"] = {
        --       cargo = {
        --         allFeatures = true,
        --         loadOutDirsFromCheck = true,
        --         runBuildScripts = true,
        --       },
        --       -- Add clippy lints for Rust.
        --       checkOnSave = {
        --         allFeatures = true,
        --         command = "clippy",
        --         extraArgs = { "--no-deps" },
        --       },
        --       procMacro = {
        --         enable = true,
        --         ignored = {
        --           ["async-trait"] = { "async_trait" },
        --           ["napi-derive"] = { "napi" },
        --           ["async-recursion"] = { "async_recursion" },
        --         },
        --       },
        --     },
        --   },
        -- },
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
    "mrcjkb/rustaceanvim",
    version = "^3", -- Recommended
    ft = { "rust" },
  },

  {
    "nvim-cmp",
    dependencies = { "crates.nvim" },
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        { name = "crates" },
      }))
    end,
  },

  -- TODO: Move to debugging
  {
    "mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "codelldb",
      })
    end,
  },

  {
    "neotest",
    dependencies = { "rouge8/neotest-rust" },
    opts = {
      adapters = {
        ["neotest-rust"] = {},
      },
    },
  },
}
