local icons = require("config").icons

return {
  {
    "glepnir/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = function(_, _)
      local opts = {
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
              icon = icons.misc.File,
              icon_hl = "DashboardProject",
              desc = "New file",
              key = "n",
              key_hl = "DashboardProject",
              action = "ene | startinsert",
            },
            {
              icon = icons.misc.Files,
              icon_hl = "DashboardRecent",
              desc = "Recent files",
              key = "r",
              key_hl = "DashboardRecent",
              action = "Telescope oldfiles",
            },
            {
              icon = icons.misc.Lazy,
              icon_hl = "DashboardLazy",
              desc = "Lazy",
              key = "l",
              key_hl = "DashboardLazy",
              action = "Lazy",
            },
            {
              icon = icons.misc.Reload,
              icon_hl = "DashboardSession",
              desc = "Last session",
              key = "s",
              key_hl = "DashboardSession",
              action = "lua require('persistence').load()",
            },
            {
              icon = icons.misc.Server,
              icon_hl = "DashboardServer",
              desc = "Mason",
              key = "m",
              key_hl = "DashboardServer",
              action = "Mason",
            },
            {
              icon = icons.misc.Quit,
              icon_hl = "DashboardQuit",
              desc = "Quit",
              key = "q",
              key_hl = "DashboardQuit",
              action = "qa",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
        },
      }

      for _, button in ipairs(opts.config.center) do
        button.desc = " " .. button.desc .. string.rep(" ", 20 - #button.desc)
      end

      return opts
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
