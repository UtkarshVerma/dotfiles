return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        arduino_language_server = {
          cmd = {
            "arduino-language-server",
            "-cli-config",
            (os.getenv("ARDUINO_DIRECTORIES_DATA") or "~/.arduino15") .. "/arduino-cli.yaml",
            "-fqbn",
            -- TODO: Remove this hardcode
            "arduino:avr:mega",
          },
        },
        clangd = {
          -- Auto-format only if .clang-format exists
          cmd = { "clangd", "--fallback-style=none" },
        },
        lemminx = {
          settings = {
            xml = {
              catalogs = { "/etc/xml/catalog" },
            },
          },
        },
        pyright = {},
        gopls = {},
        rust_analyzer = {},
        jsonls = {},
        sumneko_lua = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.ruff.with({ extra_args = { "--line-length", 79 } }),
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.formatting.clang_format.with({
            -- clangd automatically calls clang-format
            filetypes = { "arduino" },
          }),
          nls.builtins.formatting.prettierd.with({
            -- extra_args = { "--prose-wrap", "always" },
            filetype = { "markdown" },
          }),
          nls.builtins.formatting.shfmt,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.yapf,
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "ruff",
        "shellcheck",
        "shfmt",
        "stylua",
        "yapf",
      },
    },
  },
}
