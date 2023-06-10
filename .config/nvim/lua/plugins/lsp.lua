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
  cssls = {
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
      },
    },
  },
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
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
      },
    },
  },
  neocmake = {},
  texlab = {},
  html = {
    init_options = {
      provideFormatter = false, -- We'll use prettierd
    },
    capabilities = {
      textDocument = {
        completion = {
          completionItem = {
            snippetSupport = true,
          },
        },
      },
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
local setup = {
  tsserver = function(_, opts)
    -- TODO:
    -- require("lazyvim.util").on_attach(function(client, buffer)
    --   if client.name == "tsserver" then
    --     vim.keymap.set(
    --       "n",
    --       "<leader>co",
    --       "<cmd>TypescriptOrganizeImports<CR>",
    --       { buffer = buffer, desc = "Organize Imports" }
    --     )
    --     vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
    --   end
    -- end)

    require("typescript").setup({ server = opts })
    return true
  end,
}

return {
  { "b0o/SchemaStore.nvim" },
  { "jose-elias-alvarez/typescript.nvim" },
  { "folke/neodev.nvim", config = true },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "LSP Info" },
    },
    dependencies = {
      "mason-lspconfig.nvim",
      "SchemaStore.nvim",
      "typescript.nvim",
      "neodev.nvim",
    },
    opts = {
      servers = servers,
      setup = setup,
      handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" }),
      },
    },
    config = function(_, opts)
      local capabilites =
        vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), opts.capabilities or {})

      local global_server_opts = {
        capabilites = capabilites,
        handlers = opts.handlers or {},
      }

      local function setup(server, server_opts)
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        end

        if opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end

        require("lspconfig")[server].setup(vim.tbl_deep_extend("force", global_server_opts, server_opts))
      end

      for server, server_opts in pairs(opts.servers) do
        setup(server, server_opts)
      end
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    keys = {
      { "<leader>cn", "<cmd>NullLsInfo<cr>", desc = "Null LS Info" },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      automatic_installation = true,
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "null-ls.nvim",
    },
    opts = {
      automatic_installation = true,
      handlers = {},
    },
  },
  {
    "williamboman/mason.nvim",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    opts = {
      ui = { border = "rounded" },
    },
  },
}
