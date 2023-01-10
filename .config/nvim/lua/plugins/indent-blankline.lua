local icons = require("config.icons")

return {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufReadPre",
	opts = {
		char = icons.ui.LineLeft,
		context_char = icons.ui.LineLeft,
		filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
		show_trailing_blankline_indent = false,
		show_current_context = true,
	},
}
