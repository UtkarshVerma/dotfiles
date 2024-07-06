---@class lsp.clangd.config.capabilities: lsp.base.capabilities
---@field offsetEncoding? string[]

---@class lsp.clangd.config.init_options
---@field usePlaceholders? boolean
---@field completeUnimported? boolean
---@field clangdFileStatus? boolean

---@class lsp.clangd.config: lsp.base
---@field capabilities? lsp.clangd.config.capabilities
---@field init_options? lsp.clangd.config.init_options

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "c",
        "cpp",
        "make",
      })
    end,
  },

  {
    "mason.nvim",
    ---@param opts plugins.mason.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "codelldb",
      })
    end,
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        clangd = {
          keys = {
            { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch source/header (C/C++)" },
          },
          root_dir = function(file)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(file) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              file
            ) or require("lspconfig.util").find_git_ancestor(file)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
            textDocument = {
              completion = {
                completionItem = {
                  commitCharactersSupport = true,
                  insertReplaceSupport = true,
                  snippetSupport = false,
                  deprecatedSupport = true,
                  labelDetailsSupport = true,
                  preselectSupport = false,
                  resolveSupport = {
                    properties = { "documentation", "detail", "additionalTextEdits" },
                  },
                  tagSupport = {
                    valueSet = { 1 },
                  },
                },
              },
            },
          },
          cmd = {
            "clangd",
            "--clang-tidy",
            "--background-index",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--enable-config",

            -- Whitelist compilers used by PlatformIO.
            string.format("--query-driver=/usr/bin/**/clang-*,%s/**/bin/*-gcc", os.getenv("PLATFORMIO_CORE_DIR")),

            -- Auto-format only if .clang-format exists
            "--fallback-style=none",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = require("util").plugin.opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
      },
    },
  },

  {
    "nvim-cmp",
    ---@param opts plugins.cmp.config
    opts = function(_, opts)
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
    end,
  },

  {
    "p00f/clangd_extensions.nvim",
    config = function() end,
    -- TODO: Specify types
    opts = {
      inlay_hints = {
        inline = true,
      },
      ast = {
        role_icons = {
          type = "",
          declaration = "",
          expression = "",
          specifier = "",
          statement = "",
          ["template argument"] = "",
        },
        kind_icons = {
          Compound = "",
          Recovery = "",
          TranslationUnit = "",
          PackExpansion = "",
          TemplateTypeParm = "",
          TemplateTemplateParm = "",
          TemplateParamObject = "",
        },
      },
    },
  },

  {
    "nvim-dap",
    ---@type plugins.nvim_dap.config
    opts = {
      adapters = {
        gdb = {
          type = "executable",
          command = "gdb",
        },
      },
      configurations = {
        c = {
          {
            name = "Launch file",
            type = "gdb",
            request = "launch",
            program = function()
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopAtBeginningOfMainSubprogram = false,
          },
        },
      },
    },
  },
}
