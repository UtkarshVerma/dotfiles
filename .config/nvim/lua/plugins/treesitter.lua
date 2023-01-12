return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = "BufReadPost",
	dependencies = {
		"JoosepAlviste/nvim-ts-context-commentstring",
		"p00f/nvim-ts-rainbow",
		"nvim-treesitter/playground",
	},
	opts = {
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
		context_commentstring = { enable = true, enable_autocmd = false },
		rainbow = { enable = true },
		ensure_installed = {
			"bash",
			"c",
			"cpp",
			"go",
			"gomod",
			"gowork",
			"javascript",
			"latex",
			"lua",
			"markdown",
			"markdown_inline",
			"python",
			"rust",
			"typescript",
			"vim",
		},
	},
	config = function(_, opts)
		require("nvim-treesitter.configs").setup(opts)
	end,
}
