---@module "mason-lspconfig.settings"
---@module "snacks"

---@class plugins.lspconfig.config.server: vim.lsp.ClientConfig
---@field keys? plugins.lspconfig.keymap[]
---@field setup? fun(opts:plugins.lspconfig.config.server):boolean

---@class plugins.lspconfig.config
---@field capabilities? table
---@field servers? table<string, plugins.lspconfig.config.server>

---@class plugins.lspconfig.keymap
---@field [1] string
---@field [2] string|fun()
---@field desc string
---@field mode? string|string[]
---@field method? string

---@class plugins.mason_lspconfig.config: MasonLspconfigSettings

local util = require("util")

---@type plugins.lspconfig.keymap[]
local buffer_keymaps_base = {
  { "gd", "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions", method = "textDocument/definition" },
  { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", method = "textDocument/references" },
  { "gI", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations", method = "textDocument/implementation" },
  { "gD", vim.lsp.buf.declaration, desc = "Declaration", method = "textDocument/declaration" },
  { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type definition", method = "textDocument/typeDefinition" },
  { "K", vim.lsp.buf.hover, desc = "Hover", method = "textDocument/hover" },
  { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature help", method = "textDocument/signatureHelp" },
  { "<leader>cs", vim.lsp.buf.signature_help, desc = "Signature help", method = "textDocument/signatureHelp" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", method = "textDocument/codeAction" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", method = "textDocument/rename" },
  { "<leader>cc", vim.lsp.codelens.run, desc = "Run codelens", mode = { "n", "v" }, method = "textDocument/codeLens" },
  { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh and display codelens", method = "textDocument/codeLens" },
}

---Check if any LSP client in buffer {bufnr} supports {method}.
---@param method string
---@param bufnr? integer
---@return boolean
---@nodiscard
local function buffer_supports(method, bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  ---@param client vim.lsp.Client
  return vim.iter(clients):any(function(client)
    return client.supports_method(method)
  end)
end

---Apply LSP keymaps for buffer {bufnr}.
---@param bufnr integer
local function apply_buffer_keymaps(bufnr)
  local buffer_keymaps = vim.deepcopy(buffer_keymaps_base)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local opts = util.plugin.opts("nvim-lspconfig") --[[@as plugins.lspconfig.config]]

  ---@param client vim.lsp.Client
  vim.iter(clients):each(function(client)
    local server_keymaps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(buffer_keymaps, server_keymaps)
  end)

  vim
    .iter(buffer_keymaps)
    ---@param keymap plugins.lspconfig.keymap
    :filter(function(keymap)
      local method = keymap.method
      return not method or buffer_supports(method, bufnr)
    end)
    ---@param keymap plugins.lspconfig.keymap
    :each(function(keymap)
      ---@diagnostic disable-next-line: missing-fields
      vim.keymap.set(keymap.mode or "n", keymap[1], keymap[2], { desc = keymap.desc })
    end)
end

---Execute {callback} on the `LspAttach` event.
---@param callback fun(client: vim.lsp.Client, bufnr?: integer)
local function on_lsp_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      callback(client, bufnr)
    end,
  })
end

---@type LazyPluginSpec[]
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "blink.cmp",
      "snacks.nvim",
    },
    keys = {
      { "<leader>uL", "<cmd>LspInfo<cr>", "LSP information" },
    },
    ---@type  plugins.lspconfig.config
    opts = {},
    -- Let mason-lspconfig launch the language servers.
    config = function(_, _)
      on_lsp_attach(function(client, bufnr)
        apply_buffer_keymaps(bufnr)

        -- Highlight the word under cursor when it rests for some time.
        if client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
          })
        end

        -- Enable code lens.
        if vim.lsp.codelens and client.supports_method("textDocument/codeLens") then
          vim.lsp.codelens.refresh({ bufnr = bufnr })

          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = function(_)
              vim.lsp.codelens.refresh({ bufnr = bufnr })
            end,
          })
        end

        if client.supports_method("textDocument/inlayHints") then
          Snacks.toggle.inlay_hints():map("<leader>ti", { desc = "Inlay hints" })
        end
      end)
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    version = false, -- NOTE: For ginko_ls which is not present in v1.31.0.
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      "nvim-lspconfig",
    },
    opts = function(_, _)
      local lspconfig_opts = util.plugin.opts("nvim-lspconfig") --[[@as plugins.lspconfig.config]]
      local servers = lspconfig_opts.servers or {}

      -- Communicate blink.cmp's completion capabilities to all language servers.
      for _, config in pairs(servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      end

      ---@type plugins.mason_lspconfig.config
      ---@diagnostic disable-next-line: missing-fields
      return {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          -- Default handler.
          function(server)
            if not servers[server] then
              return
            end

            local server_opts = servers[server]
            if server_opts.setup and server_opts.setup(server_opts) then
              return
            end

            require("lspconfig")[server].setup(server_opts)
          end,
        },
      }
    end,
  },
}
