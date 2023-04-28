return {
  {
    "folke/noice.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        views = {
          mini = {
            win_options = {
              winblend = 0,
            },
          },
        },
        lsp = {
          progress = {
            view = "mini",
          },
        },
      })
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      render = function(bufnr, notif, highlights)
        local base = require("notify.render.base")
        local namespace = base.namespace()
        local icon = notif.icon
        local title = notif.title[1]

        local prefix = string.format("%s %s:", icon, title)
        notif.message[1] = string.format("%s %s", prefix, notif.message[1])

        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, notif.message)

        local icon_length = vim.str_utfindex(icon)
        local prefix_length = vim.str_utfindex(prefix)

        vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, 0, {
          hl_group = highlights.icon,
          end_col = icon_length + 1,
          priority = 50,
        })
        vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, icon_length + 1, {
          hl_group = highlights.title,
          end_col = prefix_length + 1,
          priority = 50,
        })
        vim.api.nvim_buf_set_extmark(bufnr, namespace, 0, prefix_length + 1, {
          hl_group = highlights.body,
          end_line = #notif.message,
          priority = 50,
        })
      end,
      stages = "static",
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        draw = {
          delay = 0,
          animation = require("mini.indentscope").gen_animation.none(),
          priority = 25,
        },
        options = {
          border = "top",
          try_as_border = false,
        },
        symbol = "▏",
      })
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        char = "▏",
        context_char = "▏",
        char_priority = 20,
        use_treesitter = true,
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = {
      "kevinhwang91/promise-async",
      "nvim-treesitter/nvim-treesitter",
    },
    init = function()
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
    end,
    opts = {
      preview = {
        mappings = {
          scrollB = "<C-b>",
          scrollF = "<C-f>",
          scrollU = "<C-u>",
          scrollD = "<C-d>",
        },
      },
      provider_selector = function(_, filetype, buftype)
        return (filetype == "" or buftype == "nofile") and "indent" -- only use indent until a file is opened
          or { "treesitter", "indent" } -- if file opened, try to use treesitter if available
      end,
    },
  },
  {
    "stevearc/vim-arduino",
    ft = "arduino",
    keys = {
      { "<leader>aa", "<cmd>ArduinoAttach<CR>", desc = "Attach Arduino" },
      { "<leader>am", "<cmd>ArduinoVerify<CR>", desc = "Verify Code" },
      { "<leader>au", "<cmd>ArduinoUpload<CR>", desc = "Upload Code" },
      { "<leader>ad", "<cmd>ArduinoUploadAndSerial<CR>", desc = "Upload and Debug" },
      { "<leader>ab", "<cmd>ArduinoChooseBoard<CR>", desc = "Choose Arduino Board" },
      { "<leader>ap", "<cmd>ArduinoChooseProgrammer<CR>", desc = "Choose Arduino Programmer" },
    },
    config = function(_, _)
      vim.g.arduino_dir = "/usr/share/arduino/"
      vim.g.arduino_home_dir = os.getenv("ARDUINO_DIRECTORIES_DATA") or "~/.arduino15"
    end,
  },
}
