return {
	"akinsho/nvim-bufferline.lua",
	event = "BufAdd",
	opts = {
		options = {
			diagnostics = "nvim_lsp",
			always_show_bufferline = false,
			diagnostics_indicator = function(_, _, diag)
				local icons = require("config.icons").diagnostics
				local ret = (diag.error and icons.Error .. diag.error .. " " or "")
					.. (diag.warning and icons.Warn .. diag.warning or "")
				return vim.trim(ret)
			end,
			offsets = {
				{
					filetype = "neo-tree",
					text = "Neo-tree",
					highlight = "Directory",
					text_align = "left",
				},
			},
		},
	},
}
