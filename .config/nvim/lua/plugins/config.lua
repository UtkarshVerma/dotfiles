require("config.options")

-- autocmds and keymaps can wait to load
vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		require("config.autocmds")
		require("config.keymaps")
	end,
})

return {}
