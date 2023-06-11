return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "<s-enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "which-key.nvim",
        opts = function(_, opts)
          opts.defaults["<leader>sn"] = { name = "+noice" }
        end,
      },
    },
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          cmdline = { icon = "  " },
          search_down = { icon = "  󰄼" },
          search_up = { icon = "  " },
          lua = { icon = "  " },
        },
      },
      lsp = {
        progress = { enabled = true },
        hover = { enabled = false },
        signature = { enabled = false },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },

      routes = {
        {
          filter = {
            event = "msg_show",
            find = "%d+L, %d+B",
          },
        },
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    dependencies = { "noice.nvim" },
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
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
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
  },
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },
  {
    "utilyre/barbecue.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      attach_navic = false,
      theme = "auto",
      include_buftypes = { "" },
      exclude_filetypes = { "gitcommit", "Trouble", "toggleterm" },
      show_modified = false,
      kinds = require("config").icons.kinds,
    },
  },
  {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      set_highlights = false,
      excluded_filetypes = {
        "prompt",
        "TelescopePrompt",
        "noice",
        "neo-tree",
        "dashboard",
        "lazy",
        "mason",
        "DressingInput",
        "cmp_docs",
        "",
      },
    },
  },
}
