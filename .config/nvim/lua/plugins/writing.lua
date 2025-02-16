---@type LazyPluginSpec[]
return {
  {
    "nvim-lspconfig",
    ---@type plugins.lspconfig.config
    opts = {
      servers = {
        harper_ls = {
          filetypes = { "markdown", "typst" },
          on_attach = function(client, _)
            local function update_spell_check()
              client.settings["harper-ls"].linters.spell_check = vim.opt.spell:get()
              client.notify("workspace/didChangeConfiguration", { settings = client.settings })
            end

            update_spell_check()

            vim.api.nvim_create_autocmd("OptionSet", {
              pattern = "spell",
              callback = update_spell_check,
            })
          end,
          settings = {
            ["harper-ls"] = {
              linters = {
                spell_check = false,
              },
              userDictPath = vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
            },
          },
        },
      },
    },
  },
}
