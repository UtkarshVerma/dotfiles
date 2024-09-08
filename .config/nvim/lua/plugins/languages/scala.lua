---@module "lazy.types"

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = { "scala" },
    },
  },

  -- TODO: lspconfig integration.
  {
    "scalameta/nvim-metals",
    dependencies = { "plenary.nvim" },
    ft = { "scala", "sbt" },
    opts = function(_, _)
      local opts = require("metals").bare_config()

      opts = vim.tbl_deep_extend("force", opts, {
        on_attach = function(_, _) end,
        init_options = {
          statusBarProvider = "off",
        },
        settings = {
          showImplicitArguments = true,
          excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        },
      })

      return opts
    end,
    config = function(self, opts)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(opts)
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
