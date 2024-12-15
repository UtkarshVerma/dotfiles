---@module "avante"
---@module "copilot"
---
---@class plugins.avante.config: avante.Config
---@class plugins.copilot.config: copilot_config

---@type LazyPluginSpec[]
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    opts = {
      file_types = { "markdown", "Avante" },
    },
  },

  {
    -- Support for image pasting.
    "HakonHarnes/img-clip.nvim",
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
    build = "make",
    dependencies = {
      "dressing.nvim",
      "plenary.nvim",
      "nvim-cmp",
      "nui.nvim",
      "nvim-web-devicons",
      "img-clip.nvim",
      "zbirenbaum/copilot.lua",
      "render-markdown.nvim",
    },
    ---@type plugins.avante.config
    opts = {
      auto_suggestions_provider = "copilot",
      provider = "claude",
      mappings = {
        suggestion = {
          accept = "<c-j>",
          next = "<m-]>",
          prev = "<m-[>",
          dismiss = "<c-]>",
        },
      },

      claude = {
        api_key_name = "cmd:rbw get --folder=api-keys anthropic avante",
      },
    },
  },
}
