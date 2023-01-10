-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@return string
local function get_root()
	local root_patterns = { ".git", "/lua" }

	---@type string?
	local path = vim.api.nvim_buf_get_name(0)
	path = path ~= "" and vim.loop.fs_realpath(path) or nil
	---@type string[]
	local roots = {}
	if path then
		for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
			local workspace = client.config.workspace_folders
			local paths = workspace
					and vim.tbl_map(function(ws)
						return vim.uri_to_fname(ws.uri)
					end, workspace)
				or client.config.root_dir and { client.config.root_dir }
				or {}
			for _, p in ipairs(paths) do
				local r = vim.loop.fs_realpath(p)
				if path:find(r, 1, true) then
					roots[#roots + 1] = r
				end
			end
		end
	end
	table.sort(roots, function(a, b)
		return #a > #b
	end)
	---@type string?
	local root = roots[1]
	if not root then
		path = path and vim.fs.dirname(path) or vim.loop.cwd()
		---@type string?
		root = vim.fs.find(root_patterns, { path = path, upward = true })[1]
		root = root and vim.fs.dirname(root) or vim.loop.cwd()
	end
	---@cast root string
	return root
end

-- this will return a function that calls telescope.
-- cwd will defautlt to lazyvim.util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
local function telescope(builtin, opts)
	local params = { builtin = builtin, opts = opts }
	return function()
		builtin = params.builtin
		opts = params.opts
		opts = vim.tbl_deep_extend("force", { cwd = get_root() }, opts or {})
		if builtin == "files" then
			if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
				opts.show_untracked = true
				builtin = "git_files"
			else
				builtin = "find_files"
			end
		end
		require("telescope.builtin")[builtin](opts)
	end
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/trouble.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
			cond = vim.fn.executable("make") == 1,
		},
	},
	cmd = "Telescope",
	version = false, -- telescope did only one release, so use HEAD for now
	keys = {
		{ "<leader>/", telescope("live_grep"), desc = "Find in Files (Grep)" },
		{ "<leader><space>", telescope("files"), desc = "Find Files (root dir)" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>ff", telescope("files"), desc = "Find Files (root dir)" },
		{ "<leader>fF", telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
		{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
		{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
		{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
		{ "<leader>ha", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
		{ "<leader>hc", "<cmd>Telescope commands<cr>", desc = "Commands" },
		{ "<leader>hf", "<cmd>Telescope filetypes<cr>", desc = "File Types" },
		{ "<leader>hh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
		{ "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
		{ "<leader>hm", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
		{ "<leader>ho", "<cmd>Telescope vim_options<cr>", desc = "Options" },
		{ "<leader>hs", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
		{ "<leader>ht", "<cmd>Telescope builtin<cr>", desc = "Telescope" },
		{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
		{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader>sg", telescope("live_grep"), desc = "Grep (root dir)" },
		{ "<leader>sG", telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
		{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
		{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
		{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{
			"<leader>ss",
			telescope("lsp_document_symbols", {
				symbols = {
					"Class",
					"Function",
					"Method",
					"Constructor",
					"Interface",
					"Module",
					"Struct",
					"Trait",
					"Field",
					"Property",
				},
			}),
			desc = "Goto Symbol",
		},
	},
	opts = {
		defaults = {
			prompt_prefix = " ",
			selection_caret = " ",
			mappings = {
				i = {
					["<c-t>"] = function(...)
						return require("trouble.providers.telescope").open_with_trouble(...)
					end,
					["<C-i>"] = function()
						telescope("find_files", { no_ignore = true })()
					end,
					["<C-h>"] = function()
						telescope("find_files", { hidden = true })()
					end,
					["<C-Down>"] = function(...)
						return require("telescope.actions").cycle_history_next(...)
					end,
					["<C-Up>"] = function(...)
						return require("telescope.actions").cycle_history_prev(...)
					end,
					["<esc>"] = function(...)
                        return require("telescope.actions").close(...)
                    end,
				},
			},
		},
	},
	config = function(_, opts)
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		telescope.load_extension("fzf")
		telescope.setup(opts)
	end,
}
