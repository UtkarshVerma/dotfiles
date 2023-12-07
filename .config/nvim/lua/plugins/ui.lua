local config = require("config")

return {
  {
    "utilyre/barbecue.nvim",
    event = "LazyFile",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-web-devicons",
    },
    opts = function(_, opts)
      local excluded_filetypes = vim.list_extend(opts.exclude_filetypes or {}, { "gitcommit" })

      return {
        attach_navic = false,
        create_autocmd = false,
        exclude_filetypes = excluded_filetypes,
        show_modified = false,
        kinds = config.icons.kinds,
      }
    end,
    config = function(_, opts)
      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })

      require("barbecue").setup(opts)
    end,
  },

  {
    "dstein64/nvim-scrollview",
    event = "LazyFile",
    opts = function(_, opts)
      local excluded_filetypes = vim.list_extend(opts.excluded_filetypes or {}, {
        "prompt",
        "lazy",
        "",
      })

      return {
        current_only = true,
        signs_on_startup = {},
        excluded_filetypes = excluded_filetypes,
      }
    end,
  },

  {
    "NvChad/nvim-colorizer.lua",
    event = "LazyFile",
    opts = {
      filetypes = { "*", "!lazy", "!neo-tree" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        virtualtext = "■",
      },
    },
  },
}
