local Util = require("lazy.core.util")

local function toggle()
  -- Format on save by default
  if vim.b.autoformat == nil then
    vim.b.autoformat = true
  end

  vim.b.autoformat = not vim.b.autoformat

  if vim.b.autoformat then
    Util.info("Enabled format on save", { title = "Format" })
  else
    Util.warn("Disabled format on save", { title = "Format" })
  end
end

local function supports_format(client)
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return false
  end
  return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

local function get_formatters(bufnr)
  local ft = vim.bo[bufnr].filetype

  -- check if we have any null-ls formatters for the current filetype
  local null_ls = package.loaded["null-ls"] and require("null-ls.sources").get_available(ft, "NULL_LS_FORTTING") or {}

  local ret = {
    active = {},
    available = {},
    null_ls = null_ls,
  }

  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if supports_format(client) then
      if (#null_ls > 0 and client.name == "null-ls") or #null_ls == 0 then
        table.insert(ret.active, client)
      else
        table.insert(ret.available, client)
      end
    end
  end

  return ret
end

local function format()
  if vim.b.autoformat == false then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local formatters = get_formatters(buf)
  local client_ids = vim.tbl_map(function(client)
    return client.id
  end, formatters.active)

  if #client_ids == 0 then
    return
  end

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      return vim.tbl_contains(client_ids, client.id)
    end,
  })
end

return {
  {
    "null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")

      opts.sources = opts.sources or {}
      opts.sources = vim.list_extend(opts.sources, {
        nls.builtins.formatting.clang_format.with({
          -- clangd automatically calls clang-format for C/C++ files
          filetypes = { "arduino" },
        }),
        nls.builtins.formatting.bibclean,
        nls.builtins.formatting.cmake_format,

        nls.builtins.formatting.cbfmt,
        nls.builtins.formatting.latexindent.with({
          -- Disable indent.log generation
          extra_args = { "-g", "/dev/null" },
        }),
        nls.builtins.formatting.rome.with({
          disabled_filetypes = { "json" },
        }),
        nls.builtins.formatting.rustfmt.with({
          extra_args = { "--edition", 2021 },
        }),
        nls.builtins.formatting.shfmt.with({
          extra_args = { "--indent", 4, "--case-indent" },
        }),
        nls.builtins.formatting.stylua,
        nls.builtins.formatting.prettierd.with({
          filetypes = { "html", "scss", "css", "markdown" },
        }),
        nls.builtins.formatting.yapf,
        nls.builtins.formatting.yamlfmt.with({
          extra_args = {
            "-formatter",
            string.format("type=basic,retain_line_breaks=true,max_line_length=%d", vim.o.colorcolumn - 1),
          },
        }),
      })
    end,
    init = function(_)
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("FormatOnSave", {}),
        callback = format,
      })

      vim.keymap.set("n", "<leader>uf", toggle, { desc = "Toggle Autoformat" })
    end,
  },
}
