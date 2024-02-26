---@diagnostic disable: lowercase-global

---@class node
---@class snippet

local luasnip = require("luasnip")

---@type fun(trigger:string, nodes:node[]):snippet
s = luasnip.snippet

---@type fun(jump_index?:integer, nodes:node[], node_opts?:table):node[]
sn = luasnip.snippet_node

---@type fun(jump_index:integer):node
i = luasnip.insert_node

---@type fun(jump_index:integer, choices:node[]|node, node_opts?:table):node
c = luasnip.choice_node

---@generic T
---@type fun(jump_index:integer, fn:fun(args:string[][], parent:node, old_state:table, user_args:T):(node), node_references?:integer[], opts?: {user_args: T})
d = luasnip.dynamic_node

---@type fun(fn:fun(node_text:string[][], parent?:node, user_args...):(string[]|string), node_references?:integer[], node_opts?:{user_args?: string[]}):node
f = luasnip.function_node

---@type fun(format:string, nodes:table<string, node>, opts?:table):node[]
fmta = require("luasnip.extras.fmt").fmta

---@type fun(text:string):node
t = luasnip.text_node
