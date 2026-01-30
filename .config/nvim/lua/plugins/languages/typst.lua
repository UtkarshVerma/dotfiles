---@module "codesettings"

---@class lsp.tinymist.config: plugins.lspconfig.config.server
---@field settings? lsp.tinymist.Tinymist

---@param client vim.lsp.Client
local function cycle_export_state(client)
  local states = { "never", "onSave", "onType" }

  local function next_state(cur)
    for i, v in ipairs(states) do
      if v == cur then
        return states[(i % #states) + 1]
      end
    end
  end

  local cur = client.settings.exportPdf or "never"
  local next = next_state(cur)

  client.settings.exportPdf = next
  client:notify("workspace/didChangeConfiguration", { settings = client.settings })
  vim.notify("Export PDF: " .. next)
end

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
    "nvim-lspconfig",
    dependencies = { "snacks.nvim" },
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@type lsp.tinymist.config
        ---@diagnostic disable-next-line: missing-fields
        tinymist = {
          keys = {
            { "<leader>te", cycle_export_state, desc = "Cycle export PDF" },
          },
          root_dir = function(bufnr, callback)
            local root_dir = vim.fs.root(bufnr, { ".git" }) or vim.fn.expand("%:p:h")
            callback(root_dir)
          end,
          -- https://myriad-dreamin.github.io/tinymist/frontend/neovim.html
          settings = {
            exportPdf = "never",
            formatterMode = "typstyle",
            lint = {
              enabled = true,
            },
          },
        },
      },
    },
  },
}
