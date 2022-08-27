local options = {
    fileencoding = "utf-8",
    backup = false,
    swapfile = false,
    clipboard = "unnamedplus", -- Use the system clipboard

    hlsearch = false, -- Don't highlight matches for previous search
    ignorecase = true, -- Do case-insensitive search
    smartcase = true, -- Do case-sensitive search if query has upper-case letters

    mouse = "a", -- Enable mouse support
    showmode = false,

    number = true,
    relativenumber = true,
    errorbells = false,

    -- Preserve undo history for files
    undodir = "/tmp/nvim-undo",
    undofile = true,

    -- Set tab width to 4 and expand tabs to spaces
    expandtab = true,
    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,

    -- Indent following line based on current indentation
    autoindent = true,
    smartindent = true,

    -- Set scroll offset to 8 lines/characters
    scrolloff = 8,
    sidescrolloff = 8,

    wrap = false,
    termguicolors = true,
    colorcolumn = "80",
    signcolumn = "yes",
    cursorline = true
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
