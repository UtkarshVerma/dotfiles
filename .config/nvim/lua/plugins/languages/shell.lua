---@class lsp.bashls.config.settings.bash_ide.shfmt
---@field caseIndent? boolean Indent patterns in case statements.

-- Borrowed from https://github.com/bash-lsp/bash-language-server/blob/main/server/src/config.ts
---@class lsp.bashls.config.settings.bash_ide
---@field globPattern? string Glob pattern for finding and parsing shell script files in the workspace. Used by the background analysis features across files.
---@field includeAllWorkspaceSymbols? boolean Controls how symbols (e.g. variables and functions) are included and used for completion, documentation, and renaming. If false, then we only include symbols from sourced files (i.e. using non dynamic statements like 'source file.sh' or '. file.sh' or following ShellCheck directives). If true, then all symbols from the workspace are included.
---@field shellcheckArguments? string[]|string Additional ShellCheck arguments. Note that we already add the following arguments: --shell, --format, --external-sources.
---@field shfmt? lsp.bashls.config.settings.bash_ide.shfmt

---@class lsp.bashls.config.settings
---@field bashIde? lsp.bashls.config.settings.bash_ide

---@class lsp.bashls.config: lsp.base
---@field settings? lsp.bashls.config.settings

-- TODO: Make this dynamically inferred.
local BASHDB_DIR = vim.fn.stdpath("data") .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir"

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@param opts plugins.treesitter.config
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
      })
    end,
  },

  {
    "mason.nvim",
    ---@param opts plugins.mason.config
    opts = function(_, opts)
      -- bashls takes care of formatting and linting both, so just ensure that they're installed.
      vim.list_extend(opts.ensure_installed, {
        "shfmt",
        "shellcheck",
        "bash-debug-adapter",
      })
    end,
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.bashls.config
        bashls = {
          filetypes = { "sh", "zsh" },
          settings = {
            bashIde = {
              includeAllWorkspaceSymbols = true,
              shellcheckArguments = { "-x" },
              shfmt = {
                caseIndent = true,
              },
            },
          },
        },
      },
    },
  },

  {
    "nvim-dap",
    ---@type plugins.nvim_dap.config
    opts = {
      adapters = {
        ["bash-debug-adapter"] = {
          type = "executable",
          command = "bash-debug-adapter",
        },
      },
      configurations = {
        {
          name = "Launch file",
          type = "bash-debug-adapter",
          request = "launch",
          program = "${file}",

          cwd = "${fileDirname}",
          pathBashdb = BASHDB_DIR .. "/bashdb",
          pathBashdbLib = BASHDB_DIR,
          pathBash = "bash",
          pathCat = "cat",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          env = { "PATH" },
          args = {},
          -- showDebugOutput = true,
          -- trace = true,
        },
      },
    },
  },
}
