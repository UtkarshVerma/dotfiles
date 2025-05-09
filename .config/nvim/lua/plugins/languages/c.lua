---@class lsp.clangd.config.capabilities: plugins.lspconfig.config.server
---@field offsetEncoding? string[]

---@class lsp.clangd.config.init_options
---@field usePlaceholders? boolean
---@field completeUnimported? boolean
---@field clangdFileStatus? boolean

---@class lsp.clangd.config: plugins.lspconfig.config.server
---@field capabilities? lsp.clangd.config.capabilities
---@field init_options? lsp.clangd.config.init_options

-- Whitelist compilers used by PlatformIO and CUDA.
local drivers = { "/usr/bin/**/clang-*" }
local platformio_dir = os.getenv("PLATFORMIO_CORE_DIR")
local cuda_path = os.getenv("CUDA_PATH")
if platformio_dir then
  drivers[#drivers + 1] = string.format("%s/**/bin/*-gcc", platformio_dir)
  drivers[#drivers + 1] = string.format("%s/**/bin/*-g++", platformio_dir)
end
if cuda_path then
  drivers[#drivers + 1] = string.format("%s/bin/nvcc", cuda_path)
end

local query_drivers = "--query-driver=" .. table.concat(drivers, ",")

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "c",
        "cpp",
        "make",
        "cuda",
      },
    },
  },

  {
    "mason.nvim",
    ---@type plugins.mason.config
    opts = {
      ensure_installed = {
        "codelldb",
      },
    },
  },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.clangd.config
        clangd = {
          keys = {
            { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch source/header (C/C++)" },
          },
          cmd = {
            "clangd",
            "--clang-tidy",
            "--background-index",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--enable-config",
            query_drivers,
            -- Auto-format only if .clang-format exists.
            "--fallback-style=none",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
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
