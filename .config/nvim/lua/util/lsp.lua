---@class util.lsp
local M = {}

---@alias util.lsp.client lsp.Client

-- Get a list of LSP clients filtered according to {filter}.
---@param bufnr? integer
---@return util.lsp.client[]
function M.get_clients(bufnr)
  return vim.lsp.get_active_clients({ bufnr = bufnr })
end

-- Execute {callback} on the `LspAttach` event.
---@param callback fun(client: util.lsp.client, bufnr?: integer)
function M.on_attach(callback)
  local util = require("util")

  util.create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      callback(client, bufnr)
    end,
  })
end

-- Get the LSP formatter.
---@return util.format.formatter
function M.formatter()
  ---@type util.format.formatter
  return {
    name = "LSP",
    priority = 1,
    format = function(bufnr)
      M.format(bufnr)
    end,
    sources = function(bufnr)
      local clients = M.get_clients(bufnr)

      ---@param client util.lsp.client
      clients = vim.tbl_filter(function(client)
        return client.supports_method("textDocument/formatting")
          or client.supports_method("textDocument/rangeFormatting")
      end, clients)

      ---@param client util.lsp.client
      return vim.tbl_map(function(client)
        return client.name
      end, clients)
    end,
  }
end

-- Format buffer {bufnr} using the LSP.
---@param bufnr? integer
function M.format(bufnr)
  local opts = { bufnr = bufnr }

  -- Use conform for formatting with LSP when available, since it has better format diffing.
  local ok, conform = pcall(require, "conform")
  if ok then
    opts.formatters = {}
    opts.lsp_fallback = true

    conform.format(opts)
    return
  end

  vim.lsp.buf.format(opts)
end

return M
