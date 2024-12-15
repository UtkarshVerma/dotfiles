---@module "mini.ai"
---@class plugins.mini.ai.config

---@class plugins.mini.ai.location
---@field line number
---@field col number

---@class plugins.mini.ai.region
---@field from? plugins.mini.ai.location
---@field to? plugins.mini.ai.location

---Get the current indent region. (taken from LazyVim)
---@param type "a"|"i"
---@nodiscard
local function get_indent_region(type)
  local spaces = (" "):rep(vim.o.tabstop)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  ---@type {line: number, indent: number, text: string}[]
  local indents = {}
  for l, line in ipairs(lines) do
    if not line:find("^%s*$") then
      indents[#indents + 1] = { line = l, indent = #line:gsub("\t", spaces):match("^%s*"), text = line }
    end
  end

  ---@type plugins.mini.ai.region[]
  local regions = {}
  for i = 1, #indents do
    if i == 1 or indents[i - 1].indent < indents[i].indent then
      local from, to = i, i
      for j = i + 1, #indents do
        if indents[j].indent < indents[i].indent then
          break
        end
        to = j
      end
      from = type == "a" and from > 1 and from - 1 or from
      to = type == "a" and to < #indents and to + 1 or to
      regions[#regions + 1] = {
        from = { line = indents[from].line, col = type == "a" and 1 or indents[from].indent + 1 },
        to = { line = indents[to].line, col = #indents[to].text },
      }
    end
  end

  return regions
end

---Get the buffer region. (taken from LazyVim)
---@param type "a"|"i"
---@nodiscard
local function get_buffer_region(type)
  local start_line = 1
  local end_line = vim.fn.line("$")

  if type == "i" then
    -- Skip first and last blank lines for `i` textobject.
    local first_nonblank = vim.fn.nextnonblank(start_line)
    local last_nonblank = vim.fn.prevnonblank(end_line)

    -- Do nothing for buffer with all blanks.
    if first_nonblank == 0 or last_nonblank == 0 then
      ---@type plugins.mini.ai.region
      return {
        from = { line = start_line, col = 1 },
      }
    end
    start_line = first_nonblank
    end_line = last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)

  ---@type plugins.mini.ai.region
  return {
    from = { line = start_line, col = 1 },
    to = { line = end_line, col = to_col },
  }
end

---Add all keymaps to which-key. (taken from LazyVim)
---@param opts plugins.mini.move.config
local function add_keymaps_to_whichkey(opts)
  local objects = {
    { " ", desc = "Whitespace" },
    { '"', desc = '" string' },
    { "'", desc = "' string" },
    { "(", desc = "() block" },
    { ")", desc = "() block with ws" },
    { "<", desc = "<> block" },
    { ">", desc = "<> block with ws" },
    { "?", desc = "User prompt" },
    { "U", desc = "Use/call without dot" },
    { "[", desc = "[] block" },
    { "]", desc = "[] block with ws" },
    { "_", desc = "Underscore" },
    { "`", desc = "` string" },
    { "a", desc = "Argument" },
    { "b", desc = ")]} block" },
    { "c", desc = "Class" },
    { "d", desc = "Digit(s)" },
    { "e", desc = "CamelCase / snake_case" },
    { "f", desc = "Function" },
    { "g", desc = "Entire file" },
    { "i", desc = "Indent" },
    { "o", desc = "Block, conditional, loop" },
    { "q", desc = "Quote `\"'" },
    { "t", desc = "Tag" },
    { "u", desc = "Use/call" },
    { "{", desc = "{} block" },
    { "}", desc = "{} with ws" },
  }

  ---@type wk.Spec
  local spec = { mode = { "o", "x" } }

  ---@type table<string, string>
  local mappings = vim.tbl_extend("force", {
    around = "a",
    inside = "i",
    around_next = "an",
    inside_next = "}in",
    around_last = "al",
    inside_last = "il",
  }, opts.mappings or {})
  mappings.goto_left = nil
  mappings.goto_right = nil

  for name, prefix in pairs(mappings) do
    name = name:gsub("^around_", ""):gsub("^inside_", "")
    spec[#spec + 1] = { prefix, group = name }
    for _, obj in ipairs(objects) do
      local desc = obj.desc
      if prefix:sub(1, 1) == "i" then
        desc = desc:gsub(" with ws", "")
      end

      spec[#spec + 1] = { prefix .. obj[1], desc = obj.desc }
    end
  end

  require("which-key").add(spec, { notify = false })
end

---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.ai",
    event = "LazyFile",
    dependencies = { "nvim-treesitter-textobjects" },
    ---@param opts plugins.mini.ai.config
    opts = function(_, opts)
      local ai = require("mini.ai")

      return vim.tbl_deep_extend("force", opts, {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          i = get_indent_region, -- indent
          g = get_buffer_region, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      })
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)

      -- This is not a hard dependency, so schedule it whenever which-key loads.
      require("util").plugin.on_load("which-key.nvim", function()
        vim.schedule(function()
          add_keymaps_to_whichkey(opts)
        end)
      end)
    end,
  },
}
