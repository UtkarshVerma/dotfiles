---@class lsp.arduino_language_server.config: lsp.base

local arduino_dir_data = os.getenv("ARDUINO_DIRECTORIES_DATA")

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "arduino",
      },
    },
  },

  {
    "mason.nvim",
    ---@type plugins.mason.config
    opts = {
      ensure_installed = {
        "clangd",
        "clang-format",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.arduino_language_server.config
        arduino_language_server = {
          cmd = {
            "arduino-language-server",

            -- NOTE: The LSP server does not automatically detect the config file, so we have to pass it manually.
            arduino_dir_data and string.format("-cli-config=%s/arduino-cli.yaml", arduino_dir_data),
          },
        },
      },
    },
  },
}
