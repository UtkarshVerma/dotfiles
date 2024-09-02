---Borrowed from:
---https://github.com/L3MON4D3/LuaSnip/blob/master/lua/luasnip/default_config.lua

---@diagnostic disable: lowercase-global

---@module "luasnip.nodes.snippet"
local snippet
s = snippet.S
sn = snippet.SN
isn = snippet.ISN

---@module "luasnip.nodes.textNode"
local textNode
t = textNode.T

---@module "luasnip.nodes.insertNode"
local insertNode
i = insertNode.I

---@module "luasnip.nodes.functionNode"
local functionNode
f = functionNode.F

---@module "luasnip.nodes.choiceNode"
local choiceNode
c = choiceNode.C

---@module "luasnip.nodes.dynamicNode"
local dynamicNode
d = dynamicNode.D

---@module "luasnip.nodes.restoreNode"
local restoreNode
r = restoreNode.R

---@module "luasnip.util.events"
local _events
events = _events

---@module "luasnip.nodes.key_indexer"
local key_indexer
k = key_indexer.new_key

---@module "luasnip.nodes.absolute_indexer"
local absolute_indexer
ai = absolute_indexer.new_absolute_index

---@module "luasnip.extras"
local _extras
extras = _extras
l = _extras.lambda
rep = _extras.rep
p = _extras.partial
m = _extras.match
n = _extras.nonempty
dl = _extras.dynamic_lambda

---@module "luasnip.extras.fmt"
local _fmt
fmt = _fmt.fmt
fmta = _fmt.fmta

---@module "luasnip.extras.expand_conditions"
local _conds
conds = _conds

---@module "luasnip.extras.postfix"
local _postfix
postfix = _postfix

---@module "luasnip.util.types"
local _types
types = _types

---@module "luasnip.util.parser"
local _parser
parse = _parser.parse_snippet

---@module "luasnip.nodes.multiSnippet"
local _multiSnippet
ms = _multiSnippet.new_multisnippet
