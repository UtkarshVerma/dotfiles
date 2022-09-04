local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then
	return
end

null_ls.setup({
	on_init = function(client, _)
		client.offset_encoding = "utf-8"
	end,
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.clang_format.with({
			extra_args = { "--style", "{ BasedOnStyle: Google, IndentWidth: 4 }" },
		}),
	},
})
