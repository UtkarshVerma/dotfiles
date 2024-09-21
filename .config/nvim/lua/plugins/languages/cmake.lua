---@module "lazy.types"

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "cmake",
      },
    },
  },

  -- {
  --   "mason.nvim",
  --   ---@type plugins.mason.config
  --   opts = {
  --     ensure_installed = {
  --       "cmakelang",
  --     },
  --   },
  -- },

  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        neocmake = {
          single_file_support = true,
          init_options = {
            format = { enable = true },
            lint = { enable = true },
            scan_cmake_in_package = true,
          },
        },
      },
    },
  },

  {
    "Civitasv/cmake-tools.nvim",
    init = function()
      local loaded = false
      local function check()
        local cwd = vim.uv.cwd()
        if vim.fn.filereadable(cwd .. "/CMakeLists.txt") == 1 then
          require("lazy").load({ plugins = { "cmake-tools.nvim" } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    opts = {},
  },

  -- {
  --   "nvim-lint",
  --   opts = {
  --     linters_by_ft = {
  --       cmake = { "cmakelint" },
  --     },
  --   },
  -- },
}
