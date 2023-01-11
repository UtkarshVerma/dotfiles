return {
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {
	-- 		style = "night",
	-- 		transparent = true,
	-- 		on_highlights = function(hl, c)
	-- 			hl.NoiceMini = { bg = c.none, fg = c.fg_float }
	-- 			hl.DiagnosticVirtualTextError.bg = c.none
	-- 			hl.DiagnosticVirtualTextWarn.bg = c.none
	-- 			hl.DiagnosticVirtualTextInfo.bg = c.none
	-- 			hl.DiagnosticVirtualTextHint.bg = c.none
	-- 		end,
	-- 	},
	-- 	config = function(_, opts)
	-- 		local tokyonight = require("tokyonight")
	-- 		tokyonight.setup(opts)
	-- 		tokyonight.load()
	-- 	end,
	-- },
	{
		"UtkarshVerma/molokai.nvim",
		dir = "~/github/molokai.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		},
		config = function(_, opts)
			local molokai = require("molokai")
			molokai.setup(opts)
			molokai.load()
		end,
	},
}
