local icons = require("icons")

-- local function start_telescope(telescope_mode)
--     local node = require("nvim-tree.lib").get_node_at_cursor()
--     local abspath = node.link_to or node.absolute_path
--     local is_folder = node.open ~= nil
--     local basedir = is_folder and abspath or vim.fn.fnamemodify(abspath, ":h")
--     require("telescope.builtin")[telescope_mode] {
--         cwd = basedir,
--     }
-- end
--
-- local function telescope_find_files(_)
--     start_telescope("find_files")
-- end
--
-- local function telescope_live_grep(_)
--     start_telescope("live_grep")
-- end

local config = {
    ignore_ft_on_setup = {
        "startify",
        "dashboard",
        "alpha",
    },
    auto_reload_on_write = false,
    hijack_directories = {
        enable = false,
    },
    update_cwd = true,
    diagnostics = {
        enable = true,
        show_on_dirs = false,
        icons = {
            hint = icons.diagnostics.BoldHint,
            info = icons.diagnostics.BoldInformation,
            warning = icons.diagnostics.BoldWarning,
            error = icons.diagnostics.BoldError,
        },
    },
    update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
    },
    system_open = {
        cmd = nil,
        args = {},
    },
    git = {
        enable = true,
        ignore = false,
        timeout = 200,
    },
    view = {
        width = 30,
        hide_root_folder = false,
        side = "left",

        mappings = {
            custom_only = true,
            list = {
                { key = { "<cr>", "<right>", "<2-LeftMouse>" }, action = "edit" },
                { key = "<C-e>", action = "edit_in_place" },
                { key = "O", action = "edit_no_picker" },
                { key = { "<c-cr>", "<2-RightMouse>" }, action = "cd" },
                -- { key = "<C-v>", action = "vsplit" },
                -- { key = "<C-x>", action = "split" },
                -- { key = "<C-t>", action = "tabnew" },
                -- { key = "<", action = "prev_sibling" },
                -- { key = ">", action = "next_sibling" },
                { key = "P", action = "parent_node" },
                { key = { "<BS>", "<left>" }, action = "close_node" },
                { key = "<Tab>", action = "preview" },
                -- { key = "K", action = "first_sibling" },
                -- { key = "J", action = "last_sibling" },
                -- { key = "C", action = "toggle_git_clean" },
                -- { key = "I", action = "toggle_git_ignored" },
                -- { key = "H", action = "toggle_dotfiles" },
                -- { key = "B", action = "toggle_no_buffer" },
                -- { key = "U", action = "toggle_custom" },
                { key = "<c-r>", action = "refresh" },
                { key = "a", action = "create" },
                { key = "d", action = "remove" },
                { key = "D", action = "trash" },
                { key = "r", action = "rename" },
                { key = "R", action = "full_rename" },
                { key = "x", action = "cut" },
                { key = "c", action = "copy" },
                { key = "p", action = "paste" },
                -- { key = "y", action = "copy_name" },
                -- { key = "Y", action = "copy_path" },
                -- { key = "gy", action = "copy_absolute_path" },
                -- { key = "[e", action = "prev_diag_item" },
                -- { key = "[c", action = "prev_git_item" },
                -- { key = "]e", action = "next_diag_item" },
                -- { key = "]c", action = "next_git_item" },
                -- { key = "-", action = "dir_up" },
                -- { key = "s", action = "system_open" },
                -- { key = "f", action = "live_filter" },
                -- { key = "F", action = "clear_live_filter" },
                { key = "q", action = "close" },
                { key = "W", action = "collapse_all" },
                -- { key = "E", action = "expand_all" },
                { key = "S", action = "search_node" },
                { key = ".", action = "run_file_command" },
                -- { key = "<C-k>", action = "toggle_file_info" },
                -- { key = "g?", action = "toggle_help" },
                -- { key = "m", action = "toggle_mark" },
                -- { key = "bmv", action = "bulk_move" },
            }
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes",
    },
    renderer = {
        indent_markers = {
            enable = true,
            icons = {
                corner = icons.ui.CornerBottomLeft,
                edge = icons.ui.LineMiddle,
                item = icons.ui.LineMiddle,
                none = " ",
            },
        },
        icons = {
            webdev_colors = true,
            show = {
                git = true,
                folder = true,
                file = true,
                folder_arrow = true,
            },
            glyphs = {
                default = icons.ui.Text,
                symlink = icons.ui.FileSymlink,
                git = {
                    deleted = icons.git.FileDeleted,
                    ignored = icons.git.FileIgnored,
                    renamed = icons.git.FileRenamed,
                    staged = icons.git.FileStaged,
                    unmerged = icons.git.FileUnmerged,
                    unstaged = icons.git.FileUnstaged,
                    untracked = icons.git.FileUntracked,
                },
                folder = {
                    default = icons.ui.Folder,
                    empty = icons.ui.EmptyFolder,
                    empty_open = icons.ui.EmptyFolderOpen,
                    open = icons.ui.FolderOpen,
                    symlink = icons.ui.FolderSymlink,
                },
            },
        },
        highlight_git = true,
        group_empty = false,
        root_folder_modifier = ":t",
    },
    filters = {
        dotfiles = false,
        custom = { "node_modules", "\\.cache" },
        exclude = {},
    },
    trash = {
        cmd = "trash",
        require_confirm = true,
    },
    log = {
        enable = false,
        truncate = false,
        types = {
            all = false,
            config = false,
            copy_paste = false,
            diagnostics = false,
            git = false,
            profile = false,
        },
    },
    actions = {
        use_system_clipboard = true,
        change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
        },
        open_file = {
            quit_on_open = false,
            resize_window = false,
            window_picker = {
                enable = true,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                    buftype = { "nofile", "terminal", "help" },
                },
            },
        },
    },
}

return {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope.nvim",
    },
    keys = { "<leader>ft", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
    config = config,
}
