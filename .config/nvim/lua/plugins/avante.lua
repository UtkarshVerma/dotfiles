---@module "avante"

---@class plugins.avante.config: avante.Config

---@type LazyPluginSpec[]
return {
  {
    -- Support for image pasting.
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    opts = {
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
      },
    },
  },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter",
      "dressing.nvim",
      "plenary.nvim",
      "nui.nvim",
      "nvim-web-devicons",
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      "img-clip.nvim",
      "markview.nvim",
    },
    lazy = false,
    ---@type plugins.avante.config
    opts = {
      auto_suggestions_provider = "copilot",
    },
    build = "make",
  },
}
