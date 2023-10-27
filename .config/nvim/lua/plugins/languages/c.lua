return {
  {
    "nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "c",
        "cpp",
        "make",
      })
      opts.context_commentstring = vim.tbl_deep_extend("force", opts.context_commentstring, {
        config = {
          c = "// %s",
          cpp = "// %s",
        },
      })
    end,
  },

  {
    "nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          keys = {
            { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
            textDocument = {
              completion = {
                completionItem = {
                  commitCharactersSupport = true,
                  insertReplaceSupport = true,
                  snippetSupport = true,
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
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--enable-config",

            -- Resolve standard include paths for cross-compilation targets
            "--query-driver=/usr/sbin/arm-none-eabi-gcc,/usr/sbin/aarch64-linux-gnu-gcc",

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
          local clangd_ext_opts = require("util").opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
      },
    },
  },

  {
    "nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
    end,
  },

  {
    "p00f/clangd_extensions.nvim",
    config = function() end,
    opts = {
      inlay_hints = {
        inline = false,
      },
      ast = {
        --These require codicons (https://github.com/microsoft/vscode-codicons)
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
}
