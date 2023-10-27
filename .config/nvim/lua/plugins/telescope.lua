local config = require("config")
local util = require("util")

return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    enabled = vim.fn.executable("make") == 1,
    config = function()
      util.on_load("telescope.nvim", function()
        require("telescope").load_extension("fzf")
      end)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "telescope-fzf-native.nvim",
      "nvim-lua/plenary.nvim",
    },
    keys = {
      { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch buffer" },
      { "<leader>/", util.telescope.show("live_grep"), desc = "Grep (root dir)" },
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      { "<leader><space>", util.telescope.show("files"), desc = "Find files (root dir)" },

      -- Find
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fc", util.telescope.config_files(), desc = "Find config file" },
      { "<leader>ff", util.telescope.show("files"), desc = "Find files (root dir)" },
      { "<leader>fF", util.telescope.show("files", { cwd = false }), desc = "Find files (cwd)" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fR", util.telescope.show("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },

      -- Git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git commits" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },

      -- Search
      { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command history" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
      { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
      { "<leader>sg", util.telescope.show("live_grep"), desc = "Grep (root dir)" },
      { "<leader>sG", util.telescope.show("live_grep", { cwd = false }), desc = "Grep (cwd)" },
      { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help pages" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search highlight groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
      { "<leader>sw", util.telescope.show("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
      { "<leader>sW", util.telescope.show("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
      { "<leader>sw", util.telescope.show("grep_string"), mode = "v", desc = "Selection (root dir)" },
      { "<leader>sW", util.telescope.show("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
      {
        "<leader>uC",
        util.telescope.show("colorscheme", { enable_preview = true }),
        desc = "Colorscheme with preview",
      },
      {
        "<leader>ss",
        function()
          require("telescope.builtin").lsp_document_symbols({ symbols = config.kind_filter.get() })
        end,
        desc = "Goto symbol",
      },
      {
        "<leader>sS",
        function()
          require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbols = config.kind_filter.get() })
        end,
        desc = "Goto symbol (workspace)",
      },
    },
    opts = function()
      local actions = require("telescope.actions")

      local open_with_trouble = function(...)
        return require("trouble.providers.telescope").open_with_trouble(...)
      end
      local open_selected_with_trouble = function(...)
        return require("trouble.providers.telescope").open_selected_with_trouble(...)
      end
      local find_files_no_ignore = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        util.telescope.show("find_files", { no_ignore = true, default_text = line })()
      end
      local find_files_with_hidden = function()
        local action_state = require("telescope.actions.state")
        local line = action_state.get_current_line()
        util.telescope.show("find_files", { hidden = true, default_text = line })()
      end

      return {
        defaults = {
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "   ",
          borderchars = {
            prompt = util.ui.generate_borderchars(
              "thick",
              nil,
              { top = "█", top_left = "█", left = "█", right = " ", top_right = " ", bottom_right = " " }
            ),
            results = util.ui.generate_borderchars(
              "thick",
              nil,
              { top = "█", top_left = "█", right = " ", top_right = " ", bottom_right = " " }
            ),
            preview = util.ui.generate_borderchars("thick", nil, { top = "█", top_left = "█", top_right = "█" }),
          },
          dynamic_preview_title = true,
          hl_result_eol = true,
          sorting_strategy = "ascending",
          results_title = "",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          -- open files in the first window that is an actual file.
          -- use the current window if no other window is available.
          get_selection_window = function()
            local wins = vim.api.nvim_list_wins()
            table.insert(wins, 1, vim.api.nvim_get_current_win())
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].buftype == "" then
                return win
              end
            end
            return 0
          end,
          mappings = {
            i = {
              ["<c-t>"] = open_with_trouble,
              ["<a-t>"] = open_selected_with_trouble,
              ["<a-i>"] = find_files_no_ignore,
              ["<a-h>"] = find_files_with_hidden,
              ["<c-down>"] = actions.cycle_history_next,
              ["<c-up>"] = actions.cycle_history_prev,
              ["<c-f>"] = actions.preview_scrolling_down,
              ["<c-b>"] = actions.preview_scrolling_up,
            },
            n = {
              ["q"] = actions.close,
            },
          },
        },
      }
    end,
  },
}
