local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
}

local dictionary = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
local words = {}
for word in io.open(dictionary, "r"):lines() do
  table.insert(words, word)
end

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
        bashls = {
          cmd_env = {
            INCLUDE_ALL_WORKSPACE_SYMBOLS = true,
          },
        },
        clangd = {
          -- Auto-format only if .clang-format exists
          cmd = { "clangd", "--enable-config", "--clang-tidy", "--fallback-style=none", "--header-insertion=never" },
        },
        ltex = {
          settings = {
            ltex = {
              language = "en-GB",
              dictionary = {
                ["en-GB"] = words,
              },
            },
          },
        },
        lemminx = {
          settings = {
            xml = {
              catalogs = { "/etc/xml/catalog" },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        gopls = {},
        rust_analyzer = {},
        rome = {},
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              format = { enable = false },
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              telemetry = { enable = false },
            },
          },
        },
      },
      setup = {
        ["*"] = function(_, opts)
          opts.handlers = handlers
          return false
        end,
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre" },
    dependencies = { "jay-babu/mason-null-ls.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.diagnostics.ruff.with({ extra_args = { "--line-length", 79 } }),
          nls.builtins.diagnostics.yamllint.with({
            extra_args = { "-d", "{extends: default, rules: {document-start: {present: false}}}" },
          }),
          nls.builtins.formatting.clang_format.with({
            -- clangd automatically calls clang-format
            filetypes = { "arduino" },
          }),
          nls.builtins.formatting.deno_fmt.with({
            filetypes = { "markdown" },
            extra_args = { "--options-line-width", 79 },
          }),
          -- nls.builtins.formatting.latexindent,
          nls.builtins.formatting.shfmt.with({
            extra_args = { "--indent", 4, "--case-indent" },
          }),
        },
      }
    end,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = {
        "alex",
        "clang_format",
        "deno_fmt",
        "hadolint",
        "latexindent",
        "markdownlint",
        "ruff",
        "shellcheck",
        "shfmt",
        "stylua",
        "yamlfmt",
        "yamllint",
        "yapf",
      },
      handlers = {},
      automatic_setup = true,
      automatic_installation = true,
    },
  },
  {
    "williamboman/mason-lspconfig",
    event = { "BufReadPre" },
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
    },
    opts = {
      automatic_installation = true,
    },
  },
  {
    "williamboman/mason.nvim",
    keys = {
      { "<leader>cm", false },
      { "<leader>m", "<cmd>Mason<cr>" },
    },
    opts = {
      ui = { border = "rounded" },
    },
  },
}
