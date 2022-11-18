local globals = {
    tex_flavor = "latex",
    vimtex_view_method = "zathura",
    vimtex_quickfix_mode = 0,
    tex_conceal = "abdmg",
}

vim.opt.conceallevel = 1;
for k, v in pairs(globals) do
    vim.g[k] = v
end
