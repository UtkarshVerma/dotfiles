local handlers = {
  ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
  ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
}

local dictionary = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
local words = {}
for word in io.open(dictionary, "r"):lines() do
  table.insert(words, word)
end

local servers = {
  bashls = {
    cmd_env = {
      INCLUDE_ALL_WORKSPACE_SYMBOLS = true,
    },
  },
  clangd = {
    cmd = {
      "clangd",
      "--enable-config",
      "--clang-tidy",
      "--header-insertion=never",

      -- Resolve standard include paths for cross-compilation targets
      "--query-driver=/usr/sbin/arm-none-eabi-gcc",

      -- Auto-format only if .clang-format exists
      "--fallback-style=none",
    },
  },
  cssls = {},
  denols = {},
  jsonls = {
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
      json = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
        validate = { enable = true },
      },
    },
  },
  neocmake = {},
  texlab = {},
  html = {
    init_options = {
      provideFormatter = false, -- We'll use prettierd
    },
  },
  ltex = {
    enabled = false,
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
  rome = {
    -- Disable JSON in favour of jsonls
    filetypes = { "javascript", "javascriptreact", "typescript", "typescript.tsx", "typescriptreact" },
  },
  tsserver = {
    settings = {
      typescript = {
        format = { enable = false },
      },
      javascript = {
        format = { enable = false },
      },
      completions = {
        completeFunctionCalls = true,
      },
    },
  },
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "b0o/SchemaStore.nvim" },
      { "jose-elias-alvarez/typescript.nvim" },
    },
    opts = {
      servers = servers,
      setup = {
        html = function(_, opts)
          opts.capabilities.textDocument.completion.completionItem.snippetSupport = true
          opts.handlers = handlers
        end,
        cssls = function(_, opts)
          opts.capabilities.textDocument.completion.completionItem.snippetSupport = true
          opts.handlers = handlers
        end,
        jsonls = function(_, opts)
          opts.capabilities.textDocument.completion.completionItem.snippetSupport = true
          opts.handlers = handlers
        end,
        tsserver = function(_, opts)
          require("lazyvim.util").on_attach(function(client, buffer)
            if client.name == "tsserver" then
              vim.keymap.set(
                "n",
                "<leader>co",
                "<cmd>TypescriptOrganizeImports<CR>",
                { buffer = buffer, desc = "Organize Imports" }
              )
              vim.keymap.set(
                "n",
                "<leader>cR",
                "<cmd>TypescriptRenameFile<CR>",
                { desc = "Rename File", buffer = buffer }
              )
            end
          end)

          opts.handlers = handlers
          require("typescript").setup({ server = opts })
          return true
        end,

        ["*"] = function(server, opts)
          if not servers[server] then
            return true
          end

          opts.handlers = handlers
          return false
        end,
      },
    },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
    },
    event = { "BufReadPre" },
    opts = function()
      local nls = require("null-ls")
      return {
        sources = {
          nls.builtins.code_actions.shellcheck,
          nls.builtins.code_actions.eslint_d,
          nls.builtins.diagnostics.alex,
          nls.builtins.diagnostics.cmake_lint,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.ruff.with({ extra_args = { "--line-length", 79 } }),
          nls.builtins.diagnostics.yamllint.with({
            extra_args = {
              "-d",
              "{extends: default, rules: {document-start: {present: false}, line-length: {max: 79}}}",
            },
          }),
          nls.builtins.formatting.clang_format.with({
            -- clangd automatically calls clang-format for C/C++ files
            filetypes = { "arduino" },
          }),
          nls.builtins.formatting.bibclean,
          nls.builtins.formatting.cmake_format,
          nls.builtins.formatting.deno_fmt.with({
            filetypes = { "markdown" },
            extra_args = { "--options-line-width", 79 },
          }),
          nls.builtins.formatting.latexindent.with({
            -- Disable indent.log generation
            extra_args = { "-g", "/dev/null" },
          }),
          require("typescript.extensions.null-ls.code-actions"),
          nls.builtins.formatting.rome.with({
            disabled_filetypes = { "json" },
          }),
          nls.builtins.formatting.rustfmt.with({
            extra_args = { "--edition", 2021 },
          }),
          nls.builtins.formatting.shfmt.with({
            extra_args = { "--indent", 4, "--case-indent" },
          }),
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.prettierd.with({
            filetypes = { "html", "scss", "css" },
          }),
          nls.builtins.formatting.yapf,
          nls.builtins.formatting.yamlfmt.with({
            extra_args = { "-formatter", "type=basic,retain_line_breaks=true,max_line_length=79" },
          }),
        },
      }
    end,
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
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre" },
    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
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
