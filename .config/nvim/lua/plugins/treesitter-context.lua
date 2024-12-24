---@module "snacks"

---@class plugins.treesitter_context.config: TSContext.Config

---@type LazyPluginSpec[]
return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    dependencies = {
      "nvim-treesitter",
      "snacks.nvim",
    },
    ---@type plugins.treesitter_context.config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      mode = "cursor",
      max_lines = 3,
    },
    config = function(_, opts)
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

      tsc.setup(opts)
    end,
  },
}
