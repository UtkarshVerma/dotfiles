---@module "mason-lspconfig.settings"

---@class plugins.lspconfig.config.server: lsp.base
---@field keys? plugins.lspconfig.key[]
---@field setup? fun(opts:plugins.lspconfig.config.server):boolean

---@class plugins.lspconfig.config
---@field capabilities? table
---@field servers? table<string, plugins.lspconfig.config.server>

---@class plugins.lspconfig.key: LazyKeysSpec
---@field method? string

---@class plugins.mason_lspconfig.config: MasonLspconfigSettings

local util = require("util")

---@type plugins.lspconfig.key[]
local keys = {
  { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp info" },
  {
    "gd",
    function()
      require("telescope.builtin").lsp_definitions({ reuse_win = true })
    end,
    desc = "Goto definition",
    method = "textDocument/definition",
  },
  { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
  { "gD", vim.lsp.buf.declaration, desc = "Goto declaration" },
  {
    "gI",
    function()
      require("telescope.builtin").lsp_implementations({ reuse_win = true })
    end,
    desc = "Goto implementation",
  },
  {
    "gt",
    function()
      require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
    end,
    desc = "Goto type definition",
  },
  { "K", vim.lsp.buf.hover, desc = "Hover" },
  { "gK", vim.lsp.buf.signature_help, desc = "Signature help", method = "textDocument/signatureHelp" },
  {
    "<c-k>",
    vim.lsp.buf.signature_help,
    mode = "i",
    desc = "Signature help",
    method = "textDocument/signatureHelp",
  },
  {
    "<leader>ca",
    vim.lsp.buf.code_action,
    desc = "Code action",
    method = "textDocument/codeAction",
  },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", method = "textDocument/rename" },
  {
    "<leader>cA",
    function()
      vim.lsp.buf.code_action({
        context = {
          only = {
            "source",
          },
          diagnostics = {},
        },
      })
    end,
    desc = "Source action",
    method = "textDocument/codeAction",
  },
  { "<leader>cc", vim.lsp.codelens.run, desc = "Run codelens", mode = { "n", "v" }, method = "textDocument/codeLens" },
  {
    "<leader>cC",
    vim.lsp.codelens.refresh,
    desc = "Refresh and display codelens",
    mode = { "n" },
    method = "textDocument/codeLens",
  },
}

-- Check if any LSP client in buffer {bufnr} supports {method}.
---@param method string
---@param bufnr? integer
---@return boolean
---@nodiscard
local function buffer_supports(method, bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end

  return false
end

-- Get keymaps for buffer {bufnr}.
---@param bufnr integer
---@return table<string, LazyKeys>
---@nodiscard
local function get_keymaps(bufnr)
  local lazy_keys = require("lazy.core.handler.keys")
  if not lazy_keys.resolve then
    return {}
  end

  local lsp_keymaps = vim.deepcopy(keys)
  local opts = util.plugin.opts("nvim-lspconfig") --[[@as plugins.lspconfig.config]]
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    local server_keymaps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(lsp_keymaps, server_keymaps)
  end

  lsp_keymaps = vim.tbl_filter(function(keymap)
    local method = keymap.method
    keymap.method = nil
    keymap.buffer = bufnr

    return not method or buffer_supports(method, bufnr)
  end, lsp_keymaps)

  return lazy_keys.resolve(lsp_keymaps)
end

-- Bind {keymaps} to buffer {bufnr}.
---@param keymaps table<string, LazyKeys>
local function bind_keys(keymaps)
  local lazy_keys = require("lazy.core.handler.keys")

  for _, keymap in pairs(keymaps) do
    local opts = lazy_keys.opts(keymap)
    vim.keymap.set(keymap.mode or "n", keymap.lhs, keymap.rhs, opts)
  end
end

-- Execute {callback} on the `LspAttach` event.
---@param callback fun(client: vim.lsp.Client, bufnr?: integer)
local function on_lsp_attach(callback)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client == nil then
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
    dependencies = { "cmp-nvim-lsp" },
    keys = {
      { "<leader>uL", "<cmd>LspInfo<cr>", "LSP information" },
    },
    init = function(_)
      on_lsp_attach(function(client, bufnr)
        -- Setup keymaps.
        local keymaps = get_keymaps(bufnr)
        bind_keys(keymaps)

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
      end)
    end,
    opts = function(_, _)
      ---@type plugins.lspconfig.config
      return {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        servers = {},
      }
    end,
    config = function(_, _) end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      "nvim-lspconfig",
    },
    opts = function(_, opts)
      local lspconfig_opts = util.plugin.opts("nvim-lspconfig") --[[@as plugins.lspconfig.config]]
      local servers = lspconfig_opts.servers or {}

      ---@type plugins.mason_lspconfig.config
      return vim.tbl_deep_extend("force", opts, {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          -- Default handler.
          function(server)
            if not servers[server] then
              return
            end

            local server_opts = vim.tbl_deep_extend("force", {
              capabilities = vim.deepcopy(lspconfig_opts.capabilities) or {},
            } --[[@as plugins.lspconfig.config.server]], servers[server])

            if server_opts.setup ~= nil then
              if server_opts.setup(server_opts) then
                return
              end
            end

            require("lspconfig")[server].setup(server_opts)
          end,
        },
      })
    end,
  },
}
