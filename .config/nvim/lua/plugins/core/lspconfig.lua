---@module "mason-lspconfig.settings"
---@module "snacks"

---@class plugins.lspconfig.config.server: vim.lsp.Config
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
  -- stylua: ignore start
  { "gd", function() Snacks.picker.lsp_definitions() end , desc = "Definitions", method = "textDocument/definition" },
  { "gr", function() Snacks.picker.lsp_references() end, desc = "References", method = "textDocument/references" },
  { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Implementations", method = "textDocument/implementation" },
  { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Type definitions", method = "textDocument/typeDefinition" },
  { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Declaration", method = "textDocument/declaration" },
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
    return client:supports_method(method)
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
    config = function(_, opts)
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
        if vim.lsp.codelens and client:supports_method("textDocument/codeLens") then
          vim.lsp.codelens.refresh({ bufnr = bufnr })

          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = bufnr,
            callback = function(_)
              vim.lsp.codelens.refresh({ bufnr = bufnr })
            end,
          })
        end

        if client:supports_method("textDocument/inlayHints") then
          Snacks.toggle.inlay_hints():map("<leader>ti", { desc = "Inlay hints" })
        end
      end)

      for server, server_opts in pairs(opts.servers or {}) do
        if server_opts.setup and server_opts.setup(server_opts) then
          return
        end

        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end
    end,
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      "nvim-lspconfig",
    },
    opts = function(_, _)
      local lspconfig_opts = util.plugin.opts("nvim-lspconfig") --[[@as plugins.lspconfig.config]]
      local servers = lspconfig_opts.servers or {}
      local external_servers = { "mojo" }

      -- Communicate blink.cmp's completion capabilities to all language servers.
      for _, config in pairs(servers) do
        config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
      end

      ---@type plugins.mason_lspconfig.config
      ---@diagnostic disable-next-line: missing-fields

      -- If NVIM_MASON_SKIP_INSTALL is set, skip automatic installation.
      local skip_install = os.getenv("NVIM_MASON_SKIP_INSTALL") == "1"

      local ensure_installed = vim
        .iter(vim.tbl_keys(servers))
        :map(function(server)
          if vim.list_contains(external_servers, server) then
            return nil
          end

          return server
        end)
        :totable()

      return {
        ensure_installed = skip_install and {} or ensure_installed,
        automatic_enable = false, -- nvim-lspconfig will enable the LSPs.
      }
    end,
  },
}
