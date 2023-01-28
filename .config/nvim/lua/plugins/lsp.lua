local border = {
  { "┌", "FloatBorder" },
  { "─", "FloatBorder" },
  { "┐", "FloatBorder" },
  { "│", "FloatBorder" },
  { "┘", "FloatBorder" },
  { "─", "FloatBorder" },
  { "└", "FloatBorder" },
  { "│", "FloatBorder" },
}
local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

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
        rome = {},
        jsonls = {},
        sumneko_lua = {
          settings = {
            Lua = {
              format = { enable = false },
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
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
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.code_actions.shellcheck,
          nls.builtins.diagnostics.alex,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.ruff.with({ extra_args = { "--line-length", 79 } }),
          nls.builtins.diagnostics.shellcheck,
          nls.builtins.formatting.shfmt.with({
            extra_args = { "--indent", 4, "--case-indent" },
          }),
          nls.builtins.diagnostics.yamllint.with({
            extra_args = {
              "-d",
              "{extends: default, rules: {document-start: {present: false}}}",
            },
          }),
          nls.builtins.formatting.clang_format.with({
            -- clangd automatically calls clang-format
            filetypes = { "arduino" },
          }),
          nls.builtins.formatting.deno_fmt.with({
            filetypes = { "markdown" },
            extra_args = { "--options-line-width", 79 },
          }),
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.yapf,
          nls.builtins.formatting.yamlfmt,
        },
      }
    end,
  },
  {
    "williamboman/mason.nvim",
    keys = {
      { "<leader>cm", false },
      { "<leader>m", "<cmd>Mason<cr>" },
    },
    opts = {
      ensure_installed = {
        "alex",
        "deno",
        "markdownlint",
        "ruff",
        "shellcheck",
        "shfmt",
        "stylua",
        "yapf",
        "yamlfmt",
        "yamllint",
      },
    },
  },
}
