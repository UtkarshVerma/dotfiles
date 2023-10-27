local icons = require("config").icons
local util = require("util")

local function hide_cursor()
  vim.cmd([[
    setlocal guicursor=n:block-Cursor
    hi Cursor blend=100
  ]])
end

local function show_cursor()
  vim.cmd([[
    setlocal guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
    hi Cursor blend=0
  ]])
end

local commands = {
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

local function name(config, node, state)
  local common = require("neo-tree.sources.common.components")
  local highlights = require("neo-tree.ui.highlights")

  local highlight = config.highlight or highlights.FILE_NAME
  local text = node.name
  if node.type == "directory" then
    highlight = highlights.DIRECTORY_NAME
    if config.trailing_slash and text ~= "/" then
      text = text .. "/"
    end
  end

  if node:get_depth() == 1 and node.type ~= "message" then
    highlight = highlights.ROOT_NAME
    text = vim.fn.fnamemodify(text, ":p:h:t")
    text = string.upper(text)
  else
    local filtered_by = common.filtered_by(config, node, state)
    highlight = filtered_by.highlight or highlight
    if config.use_git_status_colors then
      local git_status = state.components.git_status({}, node, state)
      if git_status and git_status.highlight then
        highlight = git_status.highlight
      end
    end
  end

  if type(config.right_padding) == "number" then
    if config.right_padding > 0 then
      text = text .. string.rep(" ", config.right_padding)
    end
  else
    text = text .. " "
  end

  return {
    text = text,
    highlight = highlight,
  }
end

local function icon(config, node, state)
  local common = require("neo-tree.sources.common.components")
  local highlights = require("neo-tree.ui.highlights")

  local component_icon = config.default or " "
  local highlight = config.highlight or highlights.FILE_ICON
  if node.type == "directory" then
    highlight = highlights.DIRECTORY_ICON
    if node.loaded and not node:has_children() then
      component_icon = not node.empty_expanded and config.folder_empty or config.folder_empty_open
    elseif node:is_expanded() then
      component_icon = config.folder_open or "-"
    else
      component_icon = config.folder_closed or "+"
    end
  elseif node.type == "file" or node.type == "terminal" then
    local success, web_devicons = pcall(require, "nvim-web-devicons")
    if success then
      local devicon, hl = web_devicons.get_icon(node.name, node.ext)
      component_icon = devicon or component_icon
      highlight = hl or highlight
    end
  end

  local filtered_by = common.filtered_by(config, node, state)

  -- Don't render icon in root folder
  if node:get_depth() == 1 then
    return {
      text = nil,
      highlight = highlight,
    }
  end

  return {
    text = component_icon .. " ",
    highlight = filtered_by.highlight or highlight,
  }
end

return {
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "EXPLORER",
            text_align = "center",
            separator = true, -- set to `true` if clear background of neo-tree
          },
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, position = "left", dir = util.root.get() })
        end,
        desc = "Explorer (root dir)",
        remap = true,
      },
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            dir = vim.loop.cwd(),
          })
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
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    opts = {
      source_selector = {
        winbar = true, -- toggle to show selector on winbar
        content_layout = "center",
        tabs_layout = "equal",
        show_separator_on_edge = true,
        sources = {
          { source = "filesystem", display_name = "󰉓" },
          { source = "buffers", display_name = "󰈙" },
          { source = "git_status", display_name = "󰊢" },
        },
      },
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      -- popup_border_style = util.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
      commands = commands,
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1, -- extra padding on left hand side
          -- indent guides
          with_markers = true,
          indent_marker = "│",
          last_indent_marker = "└",
          -- expander config, needed for nesting files
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "",
          folder_empty_open = "",
        },
        modified = { symbol = "" },

        git_status = { symbols = icons.git },
      },
      window = {
        width = 40,
        mappings = {
          ["<space>"] = false,
          ["<1-LeftMouse>"] = "open",
          ["l"] = "child_or_open",
          ["h"] = "parent_or_close",
        },
      },
      filesystem = {
        components = { name = name, icon = icon },
        hijack_netrw_behavior = "open_current",
        commands = commands,
        window = {
          mappings = {
            ["H"] = "navigate_up",
            ["<bs>"] = "toggle_hidden",
            ["."] = "set_root",
            ["/"] = "fuzzy_finder",
            ["f"] = "filter_on_submit",
            ["<c-x>"] = "clear_filter",
            ["a"] = { "add", config = { show_path = "relative" } }, -- "none", "relative", "absolute"
          },
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true, -- This will find and focus the file in the active buffer every
        },
        -- time the current file is changed while the tree is open.
        group_empty_dirs = true, -- when true, empty folders will be grouped together
      },
    },
    init = function()
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
          vim.cmd([[set showtabline=0]])
        end
      end

      local neotree_group = vim.api.nvim_create_augroup("neo-tree_hide_cursor", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "neo-tree",
        callback = function()
          vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertEnter" }, {
            group = neotree_group,
            callback = function()
              local fire = vim.bo.filetype == "neo-tree" and hide_cursor or show_cursor
              fire()
            end,
          })
          vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
            group = neotree_group,
            callback = function()
              show_cursor()
            end,
          })
        end,
      })
    end,
    config = function(_, opts)
      local function on_move(data)
        util.lsp.on_rename(data.source, data.destination)
      end

      local events = require("neo-tree.events")
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
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
