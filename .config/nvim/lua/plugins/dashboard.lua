return {
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(_, _)
      return {
        theme = "doom",
        hide = {
          statusline = false,
          tabline = false,
          winbar = false,
        },
        shortcut = {
          { desc = "󰚰 Update", group = "@property", action = "Lazy update", key = "u" },
        },
        config = {
          header = require("config.logo").dragon.generate("night_fury"),
          center = {
            {
              icon = "   ",
              icon_hl = "DashboardRecent",
              desc = "Recent Files",
              -- desc_hi = "String",
              key = "r",
              key_hl = "DashboardRecent",
              action = "Telescope oldfiles",
            },
            {
              icon = "   ",
              icon_hl = "DashboardSession",
              desc = "Last Session",
              -- desc_hi = "String",
              key = "s",
              key_hl = "DashboardSession",
              action = "lua require('persistence').load({last = true})",
            },
            -- {
            --   icon = "   ",
            --   icon_hl = "DashboardProject",
            --   desc = "Find Project",
            --   -- desc_hi = "String",
            --   key = "p",
            --   key_hl = "DashboardProject",
            --   action = "Telescope projects",
            -- },
            {
              icon = "   ",
              icon_hl = "DashboardConfiguration",
              desc = "Configuration",
              -- desc_hi = "String",
              key = "i",
              key_hl = "DashboardConfiguration",
              action = "edit $MYVIMRC",
            },
            {
              icon = "󰤄   ",
              icon_hl = "DashboardLazy",
              desc = "Lazy",
              -- desc_hi = "String",
              key = "l",
              key_hl = "DashboardLazy",
              action = "Lazy",
            },
            {
              icon = "   ",
              icon_hl = "DashboardServer",
              desc = "Mason",
              -- desc_hi = "String",
              key = "m",
              key_hl = "DashboardServer",
              action = "Mason",
            },
            {
              icon = "   ",
              icon_hl = "DashboardQuit",
              desc = "Quit Neovim",
              -- desc_hi = "String",
              key = "q",
              key_hl = "DashboardQuit",
              action = "qa",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return {
              "",
              "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms",
            }
          end,
        },
      }
    end,
    config = function(_, opts)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "DashboardReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("dashboard").setup(opts)
    end,
  },
}
