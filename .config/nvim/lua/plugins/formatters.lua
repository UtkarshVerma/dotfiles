local Util = require("lazy.core.util")

local config = {}

local function toggle()
  if vim.b.autoformat == false then
    vim.b.autoformat = nil
    config.autoformat = true
  else
    config.autoformat = not config.autoformat
  end

  if config.autoformat then
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
  local buf = vim.api.nvim_get_current_buf()
  if vim.b.autoformat == false then
    return
  end

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
      return vim.tbl_deep_extend("force", opts, {
        sources = {
          nls.builtins.formatting.clang_format.with({
            -- clangd automatically calls clang-format for C/C++ files
            filetypes = { "arduino" },
          }),
          nls.builtins.formatting.bibclean,
          nls.builtins.formatting.cmake_format,
          nls.builtins.formatting.deno_fmt.with({
            filetypes = { "markdown" },
            extra_args = { "--options-line-width", 79 },
          }),
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
            filetypes = { "html", "scss", "css" },
          }),
          nls.builtins.formatting.yapf,
          nls.builtins.formatting.yamlfmt.with({
            extra_args = { "-formatter", "type=basic,retain_line_breaks=true,max_line_length=79" },
          }),
        },
      })
    end,
    init = function(_)
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("FormatOnSave", {}),
        callback = function()
          format()
        end,
      })

      vim.keymap.set("n", "<leader>uf", toggle, { desc = "Toggle autoformat" })
    end,
  },
}
