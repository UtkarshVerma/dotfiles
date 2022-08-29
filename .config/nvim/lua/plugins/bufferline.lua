local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
    return
end

local highlights = {}
status_ok, _ = pcall(require, "molokai")
if status_ok then
    local c = require("molokai.colors").setup()
    local cfg = require("molokai.config")

    local accent = c.cyan
    local fg = c.fg_alt
    local bg = c.bg_popup
    local tab_fg = fg
    local tab_bg = bg
    local active_tab_fg = accent
    local active_tab_bg = cfg.transparent and c.none or c.bg

    highlights = {
        fill                  = { fg = fg, bg = bg },
        background            = { fg = tab_fg, bg = tab_bg },
        tab                   = { fg = tab_fg, bg = tab_bg },
        tab_selected          = { fg = active_tab_fg, bg = active_tab_bg },
        tab_close             = { fg = tab_fg, bg = tab_bg },
        close_button          = { fg = tab_fg, bg = tab_bg },
        close_button_visible  = { fg = active_tab_fg, bg = active_tab_bg },
        close_button_selected = { fg = active_tab_fg, bg = active_tab_bg },
        buffer_visible        = { fg = active_tab_fg, bg = active_tab_bg },
        buffer_selected       = { fg = active_tab_fg, bg = active_tab_bg, bold = false, italic = false },
        -- numbers = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- },
        -- numbers_visible = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- },
        -- numbers_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        -- diagnostic = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- },
        -- diagnostic_visible = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        -- },
        -- diagnostic_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        -- hint = {
        --     fg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        -- },
        -- hint_visible = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        -- },
        -- hint_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>'
        --     bold = true,
        --     italic = true,
        -- },
        -- hint_diagnostic = {
        --     fg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        -- },
        -- hint_diagnostic_visible = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        -- },
        -- hint_diagnostic_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>'
        --     bold = true,
        --     italic = true,
        -- },
        -- info = {
        --     fg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        -- },
        -- info_visible = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        -- },
        -- info_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>'
        --     bold = true,
        --     italic = true,
        -- },
        -- info_diagnostic = {
        --     fg = '<colour-value-here>',
        --     sp = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        -- },
        -- info_diagnostic_visible = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        -- },
        -- info_diagnostic_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     sp = '<colour-value-here>'
        --     bold = true,
        --     italic = true,
        -- },
        modified              = { fg = tab_fg, bg = tab_bg },
        modified_visible      = { fg = active_tab_fg, bg = active_tab_bg },
        modified_selected     = { fg = active_tab_fg, bg = active_tab_bg },
        -- duplicate_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        --     italic = true,
        -- },
        -- duplicate_visible = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        --     italic = true
        -- },
        -- duplicate = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>'
        --     italic = true
        -- },
        separator             = { fg = bg, bg = bg },
        separator_selected    = { fg = bg, bg = active_tab_bg },
        separator_visible     = { fg = bg, bg = active_tab_bg },

        indicator_selected = { fg = accent, bg = active_tab_bg },
        -- pick_selected = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        -- pick_visible = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        -- pick = {
        --     fg = '<colour-value-here>',
        --     bg = '<colour-value-here>',
        --     bold = true,
        --     italic = true,
        -- },
        -- offset_separator = {
        --     fg = win_separator_fg,
        --     bg = separator_background_color,
        -- },
    }
end

bufferline.setup({
    options = {
        buffer_close_icon = "",
        modified_icon = "",
        max_name_length = 14,
        max_prefix_length = 13,
        tab_size = 20,
        separator_style = "thin",
        show_close_icon = false
    },
    highlights = highlights
})
