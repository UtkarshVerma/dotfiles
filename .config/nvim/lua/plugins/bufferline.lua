local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
    return
end

bufferline.setup({
    options = {
        mode = "tabs",
        separator_style = "slant",
        always_show_bufferline = false,
        show_close_icon = false,
        color_icons = true
    }
})

vim.keymap.set("n", "<tab>", "<cmd>BuferLineCycleNext<cr>", {})
vim.keymap.set("n", "<s-tab>", "<cmd>BuferLineCyclePrev<cr>", {})
