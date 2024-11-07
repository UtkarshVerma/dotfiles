---@alias plugins.mini.surround.mapping "add"|"delete"|"find"|"find_left"|"highlight"|"replace"|"update_n_lines"|"suffix_last"|"suffix_next"

---@class plugins.mini.surround.config
---@field n_lines? integer
---@field mappings? table<plugins.mini.surround.mapping, string>

---@type LazyPluginSpec[]
return {
  {
    "which-key.nvim",
    ---@type plugins.which_key.config
    opts = {
      spec = {
        { "gs", group = "surrounding" },
      },
    },
  },

  {
    "echasnovski/mini.surround",
    keys = function(plugin, keys)
      local opts = plugin.opts --[[@as plugins.mini.surround.config]]

      local mappings = {
        { opts.mappings.add, desc = "Add", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete" },
        { opts.mappings.find, desc = "Find right" },
        { opts.mappings.find_left, desc = "Find left" },
        { opts.mappings.highlight, desc = "Highlight" },
        { opts.mappings.replace, desc = "Replace" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }

      ---@param mapping LazyKeys
      mappings = vim.tbl_filter(function(mapping)
        return mapping[1] and #mapping[1] > 0
      end, mappings)
      vim.list_extend(mappings, keys)

      return mappings
    end,
    ---@type plugins.mini.surround.config
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },
}
