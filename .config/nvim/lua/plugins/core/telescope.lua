---@class util.telescope.picker.shared.layout_config
---@field anchor? ""|"CENTER"|"NW"|"N"|"NE"|"E"|"SE"|"S"|"SW"|"W"
---@field height? integer
---@field mirror? boolean
---@field prompt_position? "bottom"|"top"
---@field scroll_speed? integer
---@field width? number

---@class util.telescope.picker.horizontal.layout_config: util.telescope.picker.shared.layout_config
---@field preview_cutoff? integer
---@field preview_width? number

---@class util.telescope.layout_config
---@field horizontal? util.telescope.picker.horizontal.layout_config

---@class util.telescope.config.defaults
---@field prompt_prefix? string
---@field selection_caret? string
---@field entry_prefix? string
---@field border? boolean
---@field borderchars? table<"prompt"|"results"|"preview", util.ui.border.chars>
---@field get_status_text? fun(picker):string
---@field sorting_strategy? "ascending"|"descending"
---@field results_title? string
---@field layout_config? util.telescope.layout_config

---@class util.telescope.config
---@field defaults? util.telescope.config.defaults

local config = require("config")
local util = require("util")

---@param opts? {cwd?: string}
local function live_multi_grep(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local make_entry = require("telescope.make_entry")

  local finder = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")
      local cmd = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
      }
      if pieces[1] then
        vim.list_extend(cmd, { "--regexp", pieces[1] })
      end

      if pieces[2] then
        vim.list_extend(cmd, { "--glob", pieces[2] })
      end

      return cmd
    end,
    cwd = opts.cwd,
    entry_maker = make_entry.gen_from_vimgrep(opts),
  })

  pickers
    .new(opts, {
      prompt_title = "Multi Grep",
      debounce = 100,
      finder = finder,
      previewer = require("telescope.config").values.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(), -- rg already sorts the results.
    })
    :find()
end

---Return a function that spawns telescope with the `git_files` or `find_files` picker, depending on existence of the
---`.git` folder.
---@param opts? {cwd?: string|boolean}
---@return fun()
local function search_files(opts)
  return function()
    opts = opts or {}
    local cwd = opts.cwd or util.fs.cwd()
    local path_sep = util.fs.path_sep

    local picker = "find_files"
    if vim.uv.fs_stat(cwd .. path_sep .. ".git") then
      opts["show_untracked"] = true
      picker = "git_files"
    end

    require("telescope.builtin")[picker](opts)
  end
end

---@type LazyPluginSpec[]
return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    dependencies = { "telescope.nvim" },
    build = "make",
    enabled = vim.fn.executable("make") == 1,
    config = function(_, _)
      util.plugin.on_load("telescope.nvim", function()
        require("telescope").load_extension("fzf")
      end)
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "plenary.nvim" },
    ---@type fun(_:LazyPlugin, _:LazyKeysSpec):LazyKeys[]
    keys = function(_, _)
      local builtin = require("telescope.builtin")

      return {
        -- Find
        { "<leader>fb", builtin.buffers, desc = "Buffers" },
        { "<leader>fc", search_files({ cwd = vim.fn.stdpath("config") }), desc = "Config file" },
        { "<leader>ff", search_files(), desc = "Files" },
        { "<leader>fr", builtin.oldfiles, desc = "Recent" },

        -- Git
        { "<leader>gc", builtin.git_commits, desc = "Commits" },
        { "<leader>gs", builtin.git_status, desc = "Status" },

        -- Search
        { "<leader>sr", builtin.registers, desc = "Registers" },
        { "<leader>sa", builtin.autocommands, desc = "Auto commands" },
        { "<leader>sb", builtin.current_buffer_fuzzy_find, desc = "Buffer" },
        { "<leader>sc", builtin.command_history, desc = "Command history" },
        { "<leader>sC", builtin.commands, desc = "Commands" },
        -- stylua: ignore
        { "<leader>sd", function() builtin.diagnostics({ bufnr = 0 }) end, desc = "Document diagnostics" },
        { "<leader>sD", builtin.diagnostics, desc = "Workspace diagnostics" },
        -- stylua: ignore
        { "<leader>sg", function() live_multi_grep() end, desc = "Grep" },
        { "<leader>sh", builtin.help_tags, desc = "Help pages" },
        { "<leader>sH", builtin.highlights, desc = "Search highlight groups" },
        { "<leader>sk", builtin.keymaps, desc = "Keymaps" },
        { "<leader>sM", builtin.man_pages, desc = "Man pages" },
        { "<leader>sm", builtin.marks, desc = "Jump to mark" },
        { "<leader>so", builtin.vim_options, desc = "Options" },
        { "<leader>sR", builtin.resume, desc = "Resume" },
        -- stylua: ignore
        { "<leader>sw", function() builtin.grep_string({ word_match = "-w" }) end, desc = "Word" },
        { "<leader>sw", builtin.grep_string, mode = "v", desc = "Selection" },
        {
          "<leader>uc",
          function()
            builtin.colorscheme({ enable_preview = true })
          end,
          desc = "Colorscheme with preview",
        },
        -- stylua: ignore start
        { "<leader>ss", function() builtin.lsp_document_symbols() end, desc = "Goto symbol" },
        { "<leader>sS", function() builtin.lsp_dynamic_workspace_symbols() end, desc = "Goto symbol (workspace)" },
        -- stylua: ignore end
      }
    end,

    ---@type util.telescope.config
    opts = {
      defaults = {
        prompt_prefix = " " .. config.icons.misc.Search .. " ",
        selection_caret = config.icons.misc.ChevronRight .. " ",
        entry_prefix = "  ",
        borderchars = {
          prompt = util.ui.borderchars("thick"),
          results = util.ui.borderchars("thick"),
          preview = util.ui.borderchars("thick"),
        },
        sorting_strategy = "ascending",
        results_title = "",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
          },
        },
      },
    },
  },
}
