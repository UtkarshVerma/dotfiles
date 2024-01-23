local config = require("config")
local util = require("util")

local M = {}

M.keys = {
  { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp info" },
  {
    "gd",
    function()
      require("telescope.builtin").lsp_definitions({ reuse_win = true })
    end,
    desc = "Goto definition",
    has = "definition",
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
    "gy",
    function()
      require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
    end,
    desc = "Goto t[y]pe definition",
  },
  { "K", vim.lsp.buf.hover, desc = "Hover" },
  { "gK", vim.lsp.buf.signature_help, desc = "Signature help", has = "signatureHelp" },
  { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature help", has = "signatureHelp" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" }, has = "codeAction" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
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
    has = "codeAction",
  },
}

---@param method string
function M.has(buffer, method)
  method = method:find("/") and method or "textDocument/" .. method
  local clients = util.lsp.clients(buffer)
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end

  return false
end

---@return (LazyKeys|{has?:string})[]
function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = M.keys
  local opts = util.plugin.opts("nvim-lspconfig")
  local clients = util.lsp.clients(buffer)
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or M.has(buffer, keys.has) then
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "mason-lspconfig.nvim", "cmp-nvim-lsp" },
    event = "LazyFile",
    ---@class plugins.lsp.opts
    opts = function(_, _)
      return {
        -- options for vim.diagnostic.config()
        diagnostics = {
          underline = true,
          update_in_insert = true,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
          },
          virtual_lines = false,
          severity_sort = true,
          float = {
            focusable = false,
            style = "minimal",
            source = "if_many",
            border = util.ui.borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        -- LSP Server Settings
        servers = {},
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:table):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
    end,
    config = function(_, opts)
      -- setup autoformat
      util.format.register(util.lsp.formatter())

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

      -- setup keymaps
      util.lsp.on_attach(function(client, buffer)
        M.on_attach(client, buffer)
      end)

      local register_capability = vim.lsp.handlers["client/registerCapability"]
      vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
        local ret = register_capability(err, res, ctx)
        local client_id = ctx.client_id
        ---@type lsp.Client
        local client = vim.lsp.get_client_by_id(client_id)
        local buffer = vim.api.nvim_get_current_buf()
        M.on_attach(client, buffer)
        return ret
      end

      -- diagnostics
      for name, icon in pairs(config.icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

      if opts.inlay_hints.enabled and inlay_hint then
        util.lsp.on_attach(function(client, buffer)
          if client.supports_method("textDocument/inlayHint") then
            inlay_hint(buffer, true)
          end
        end)
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            local icons = config.icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), opts.capabilities)

      local function setup(server)
        if not servers[server] then
          return
        end

        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server])

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end

        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      local mlsp = require("mason-lspconfig")
      mlsp.setup({ ensure_installed = ensure_installed, handlers = { setup } })
    end,
  },
}
