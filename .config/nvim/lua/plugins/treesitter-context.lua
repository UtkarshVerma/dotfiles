---@module "snacks"

---@class plugins.treesitter_context.config
---@field max_lines? integer
---@field mode? "cursor"|"topline"
---@field on_attach? fun(bufnr:number):boolean

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    dependencies = {
      "nvim-treesitter",
      "snacks.nvim",
    },
    opts = function(_, _)
      local tsc = require("treesitter-context")

      Snacks.toggle
        .new({
          name = "Treesitter context",
          get = tsc.enabled,
          set = function(state)
            if state then
              tsc.enable()
            else
              tsc.disable()
            end
          end,
        })
        :map("<leader>tc", { desc = "Treesitter context" })

      ---@type plugins.treesitter_context.config
      return { mode = "cursor", max_lines = 3 }
    end,
  },
}
