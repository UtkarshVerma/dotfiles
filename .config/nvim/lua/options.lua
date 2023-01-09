local options = {
    hlsearch       = false, -- Don't highlight matches for previous search
    mouse          = "a", -- Enable mouse mode
    breakindent    = true, -- Enable break indent
    undofile       = true, -- Save undo history
    updatetime     = 250, -- Decrease update time
    number         = true, -- Enable line numbers
    relativenumber = true, -- Enable relative numbers
    signcolumn     = "yes", -- Enable sign column

    -- Case insensitive searching UNLESS /C or capital in search
    ignorecase = true,
    smartcase = true,

    backup = false,
    swapfile = false,
    clipboard = "unnamedplus", -- Use the system clipboard

    showmode = false,
    errorbells = false,

    -- Set scroll offset to 8 lines/characters
    scrolloff = 8,
    sidescrolloff = 8,

    -- Show non-printable characters for ease of use
    showbreak = "↪ ",
    list = true,
    listchars = "tab:» ,eol:↴,extends:⟩,precedes:⟨,nbsp:␣,trail:·",

    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,

    wrap = false,
    title = true,
    termguicolors = true,
    colorcolumn = "80",
    cursorline = true,
}

for k, v in pairs(options) do
    vim.opt[k] = v
end
