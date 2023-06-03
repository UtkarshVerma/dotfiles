return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      local global_commands = {
        system_open = function(state)
          local cmd = { "xdg-open" }
          local path = state.tree:get_node():get_id()
          vim.fn.jobstart(vim.fn.extend(cmd, { path or vim.fn.expand("<cfile>") }), { detach = true })
        end,
        parent_or_close = function(state)
          local node = state.tree:get_node()
          if (node.type == "directory" or node:has_children()) and node:is_expanded() then
            state.commands.toggle_node(state)
          else
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        child_or_open = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" or node:has_children() then
            if not node:is_expanded() then -- if unexpanded, expand
              state.commands.toggle_node(state)
            else -- if expanded and has children, seleect the next child
              require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
            end
          else -- if not a directory just open it
            state.commands.open(state)
          end
        end,
      }

      return vim.tbl_deep_extend("force", opts, {
        window = {
          mappings = {
            ["<space>"] = false, -- disable space until we figure out which-key disabling
            ["[b"] = "prev_source",
            ["]b"] = "next_source",
            ["o"] = "open",
            ["O"] = "system_open",
            ["h"] = "parent_or_close",
            ["l"] = "child_or_open",
          },
        },
        filesystem = {
          follow_current_file = true,
          hijack_netrw_behavior = "open_current",
          use_libuv_file_watcher = true,
          commands = global_commands,
        },
        buffers = { commands = global_commands },
        git_status = { commands = global_commands },
      })
    end,
  },
  {
    "NMAC427/guess-indent.nvim",
    event = { "BufReadPre" },
    config = true,
  },
  { "RRethy/vim-illuminate", enabled = false },
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      require("which-key").register({
        ["<leader>d"] = {
          name = "+debug",
        },
      })
      return vim.tbl_deep_extend("force", opts, {
        plugins = {
          presets = {
            windows = false, -- disable as it interferes with <c-w> mapping
          },
        },
      })
    end,
  },
  {
    "echasnovski/mini.comment",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        options = {
          ignore_blank_line = true,
        },
      })
    end,
  },
  {
    "vimwiki/vimwiki",
    init = function()
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_list = {
        {
          auto_export = 0,
          path_html = "~/notes/output/",
          path = "~/notes/vimwiki/",
          syntax = "default",
          ext = ".wiki",
        },
        {
          path = "~/notes/gsi/",
          syntax = "markdown",
          ext = ".md",
        },
      }
    end,
    cmd = "VimwikiIndex",
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        defaults = {
          mappings = {
            i = { ["<esc>"] = require("telescope.actions").close },
          },
        },
      })
    end,
  },
}
