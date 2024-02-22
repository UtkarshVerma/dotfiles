---@alias plugins.mini.pairs.action "open"|"close"|"closeopen"
---@alias plugins.mini.pairs.mode "insert"|"command"|"terminal"

---@class plugins.mini.pairs.mapping
---@field action? plugins.mini.pairs.action
---@field pair? string
---@field neigh_pattern? string
---@field register? {cr?: boolean}

---@class plugins.mini.pairs.config
---@field modes? table<plugins.mini.pairs.mode, boolean>
---@field mappings? table<string, plugins.mini.pairs.mapping>

---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    ---@type plugins.mini.pairs.config
    opts = {
      -- Do not expand pairs if previous character is a backslash.
      mappings = {
        ["("] = { action = "open", pair = "()", neigh_pattern = "[^\\]." },
        ["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\]." },
        ["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\]." },

        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },

        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
      },
    },
  },
}
