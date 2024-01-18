local icons = require("config").icons
local util = require("util")

---@param data {source:string, destination:string}
local function on_move(data)
  util.lsp.on_rename(data.source, data.destination)
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      "nui.nvim",
      "plenary.nvim",
      "nvim-web-devicons",
    },
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = util.root.get() })
        end,
        desc = "Explorer (root dir)",
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer (cwd)",
      },
      {
        "<leader>ge",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      {
        "<leader>be",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffer explorer",
      },
    },
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(tostring(vim.fn.argv(0)))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      popup_border_style = util.ui.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
      event_handlers = {
        { event = "neo_tree_window_after_open", handler = util.neo_tree.hide_cursor },
        { event = "neo_tree_buffer_enter", handler = util.neo_tree.hide_cursor },
        { event = "neo_tree_window_before_close", handler = util.neo_tree.show_cursor },
        { event = "neo_tree_buffer_leave", handler = util.neo_tree.show_cursor },
        { event = "file_moved", handler = on_move },
        { event = "file_renamed", handler = on_move },
      },
      default_component_configs = {
        indent = {
          expander_collapsed = icons.misc.ExpanderCollapsed,
          expander_expanded = icons.misc.ExpanderExpanded,
        },
        icon = {
          folder_closed = icons.misc.FolderClosed,
          folder_open = icons.misc.FolderOpen,
          folder_empty = icons.misc.FolderEmpty,
          folder_empty_open = icons.misc.FolderEmptyOpen,
        },
        modified = { symbol = icons.misc.Modified },
        git_status = { symbols = icons.git },
      },
      commands = {
        parent_or_collapse = util.neo_tree.parent_or_collapse,
        child_or_expand = util.neo_tree.child_or_expand,
      },
      window = {
        mappings = {
          ["<space>"] = false,
          ["l"] = "child_or_expand",
          ["h"] = "parent_or_collapse",
        },
      },
      filesystem = {
        window = {
          mappings = {
            ["H"] = "navigate_up",
            ["."] = "set_root",
            ["/"] = "fuzzy_finder",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["a"] = { "add", config = { show_path = "relative" } },
          },
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)

      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
}
