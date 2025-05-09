---@class lsp.harper_ls.settings.linters
---@field SpellCheck? boolean Looks and provides corrections for misspelled words. Defaults to true.

---@alias lsp.harper_ls.dialects
---| "American" American English
---| "British" British English
---| "Australian" Australian English
---| "Canadian" Canadian English

---Borrowed from https://writewithharper.com/docs/integrations/language-server#Configuration
---@class lsp.harper_ls.settings
---@field linters? lsp.harper_ls.settings.linters
---@field userDictPath? string Path to the user dictionary file.
---@field dialect? lsp.harper_ls.dialects Dialect to use for spell checking. Defaults to American English.

---@type LazyPluginSpec[]
return {
  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        ---@diagnostic disable-next-line: missing-fields
        harper_ls = {
          filetypes = { "markdown", "typst" },
          on_attach = function(client, _)
            local function update_spell_check()
              local settings = client.settings["harper-ls"] --[[@as lsp.harper_ls.settings]]
              settings.linters.SpellCheck = vim.opt.spell:get()
              client:notify("workspace/didChangeConfiguration", { settings = client.settings })
            end

            update_spell_check()

            vim.api.nvim_create_autocmd("OptionSet", {
              pattern = "spell",
              callback = update_spell_check,
            })
          end,
          settings = {
            ---@type lsp.harper_ls.settings
            ["harper-ls"] = {
              linters = {
                SpellCheck = false,
              },
              userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
              dialect = "British",
            },
          },
        },
      },
    },
  },
}
