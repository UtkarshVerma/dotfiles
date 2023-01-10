return {
	"rcarriga/nvim-notify",
	keys = {
		{
			"<leader>nd",
			function()
				require("notify").dismiss({ silent = true, pending = true })
			end,
			desc = "Delete all Notifications",
		},
	},
	opts = function()
		local icons = require("config.icons").diagnostics
		return {
			timeout = 3000,
			stages = "slide",
			icons = {
				DEBUG = icons.Debug,
				ERROR = icons.Error,
				INFO = icons.Info,
				TRACE = icons.Trace,
				WARN = icons.Warn,
			},
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
		}
	end,
	init = function()
		-- lazy-load notify here. Will be overriden by Noice when it loads
		vim.notify = function(...)
			return require("notify").notify(...)
		end
	end,
}
