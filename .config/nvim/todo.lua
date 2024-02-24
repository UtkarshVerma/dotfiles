-- NOTE: LSP
-- Add padding to codelens text if listchars for "eol" is set.
local is_newline_shown = vim.opt.list:get() and vim.opt.listchars:get()["eol"]
if is_newline_shown then
  local code_lens = vim.lsp.codelens.on_codelens
  vim.lsp.codelens.on_codelens = function(err, lenses, ctx)
    if lenses then
      for i, lens in pairs(lenses) do
        if lens.command and lens.command.title then
          lenses[i].command.title = " " .. lens.command.title
        end
      end
    end

    code_lens(err, lenses, ctx)
  end
end
