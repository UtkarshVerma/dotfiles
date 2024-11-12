---@module "avante"
---@module "copilot"

---@class plugins.avante.config: avante.Config
---@class plugins.copilot.config: copilot_config

---@type LazyPluginSpec[]
return {
  {
    "zbirenbaum/copilot.lua",
    ---@type plugins.copilot.config
    opts = {
      suggestion = {
        keymap = {
          accept = "M-l",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
    },
  },

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
    lazy = false,
    build = "make",
    dependencies = {
      "nvim-treesitter",
      "dressing.nvim",
      "plenary.nvim",
      "nui.nvim",
      "nvim-web-devicons",
      "img-clip.nvim",
      "copilot.lua",
      "markview.nvim",
    },
    ---@type plugins.avante.config
    opts = {
      auto_suggestions_provider = "copilot",
      provider = "claude",
      claude = {
        api_key_name = "cmd:gopass show --password api-keys/anthropic_avante",
      },
    },
  },
}
