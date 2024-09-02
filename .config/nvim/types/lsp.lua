---@meta

---@class lsp.base.capabilities.text_document.completion.completion_item
---@field commitCharactersSupport? boolean
---@field insertReplaceSupport? boolean
---@field snippetSupport? boolean
---@field deprecatedSupport? boolean
---@field labelDetailsSupport? boolean
---@field preselectSupport? boolean
---@field resolveSupport? {properties: string[]}
---@field tagSupport? {valueSet: integer[]}

---Defined at https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_completion
---@class lsp.base.capabilities.text_document.completion
---@field completionItem? lsp.base.capabilities.text_document.completion.completion_item

---@class lsp.base.capabilites.text_document
---@field completion? lsp.base.capabilities.text_document.completion

---Defined at https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#capabilities
---@class lsp.base.capabilities
---@field offsetEncoding? string[]
---@field textDocument? lsp.base.capabilites.text_document

---Refer to :h lspconfig-setup.
---@class lsp.base
---@field cmd? string[]
---@field capabilities? table
---@field on_attach? fun(client:lsp.Client, bufnr:integer):integer
---@field filetypes? string[]
---@field root_dir? fun(file:string):string
---@field on_new_config fun(new_config:lsp.base, new_root_dir:string)
