---@module "lazy.types"

local util = require("util")

---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      spec = {
        { "<leader>m", group = "metals" },
      },
    },
  },

  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = { "scala" },
    },
  },

  {
    "scalameta/nvim-metals",
    dependencies = { "plenary.nvim" },
    ft = { "scala", "sbt" },
    opts = function(_, _)
      local map = vim.keymap.set

      return {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        on_attach = function(_, _)
          local metals = require("metals")
          metals.setup_dap()

          map("n", "<leader>ws", function()
            metals.hover_worksheet()
          end, { desc = "Hover worksheet" })

          map("n", "<leader>mc", function()
            metals.compile_cascade()
          end, { desc = "Compile cascade" })

          map("n", "<leader>me", function()
            require("telescope").extensions.metals.commands()
          end, { desc = "Commands" })
        end,
        init_options = {
          statusBarProvider = "off",
        },
        settings = {
          showImplicitArguments = true,
          excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
          inlayHints = {
            inferredTypes = { enable = true },
            implicitConversions = { enable = true },
          },
        },
      }
    end,
    config = function(self, opts)
      local metals = require("metals")
      local metals_config = vim.tbl_deep_extend("force", metals.bare_config(), opts)

      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          metals.initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end,
  },

  {
    "nvim-dap",
    ---@type plugins.nvim_dap.config
    opts = {
      configurations = {
        scala = {
          {
            type = "scala",
            request = "launch",
            name = "RunOrTest",
            metals = {
              runType = "runOrTestFile",
              --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
            },
          },
          {
            type = "scala",
            request = "launch",
            name = "Test Target",
            metals = {
              runType = "testTarget",
            },
          },
        },
      },
    },
  },
}
