---@module "snacks"

---@class lsp.tinymist.config.settings
---@field exportPdf? "onType"|"onSave"|"never"
---@field serverPath? string

---@class lsp.tinymist.config: plugins.lspconfig.config.server
---@field settings? lsp.tinymist.config.settings

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter",
    ---@type plugins.treesitter.config
    opts = {
      ensure_installed = {
        "typst",
      },
    },
  },

  {
    "kaarmu/typst.vim",
    ft = "typst",
  },

  {
    "nvim-lspconfig",
    dependencies = { "snacks.nvim" },
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.tinymist.config
        ---@diagnostic disable-next-line: missing-fields
        tinymist = {
          root_dir = function(bufnr, callback)
            local root_dir = vim.fs.root(bufnr, { ".git" }) or vim.fn.expand("%:p:h")
            callback(root_dir)
          end,
          on_attach = function(client, _)
            Snacks.toggle
              .new({
                name = "Export PDF on type",
                get = function()
                  return client.settings.exportPdf == "onType"
                end,
                set = function(state)
                  ---@type lsp.tinymist.config.settings
                  if state then
                    client.settings.exportPdf = "onType"
                  else
                    client.settings.exportPdf = "never"
                  end

                  client:notify("workspace/didChangeConfiguration", { settings = client.settings })
                end,
              })
              :map("<leader>te", { desc = "Export PDF on type" })
          end,
          settings = {
            exportPdf = "never",
          },
        },
      },
    },
  },

  {
    "conform.nvim",
    ---@type plugins.conform.config
    opts = {
      formatters_by_ft = {
        typst = { "typstyle" },
      },
    },
  },
}
