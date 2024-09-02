---@module "lazy"
---@module "which-key"

---@alias Mini.ai.loc {line:number, col:number}
---@alias Mini.ai.region {from:Mini.ai.loc, to:Mini.ai.loc}

-- Taken from LazyVim.
local function ai_indent(ai_type)
  local spaces = (" "):rep(vim.o.tabstop)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local indents = {} ---@type {line: number, indent: number, text: string}[]

  for l, line in ipairs(lines) do
    if not line:find("^%s*$") then
      indents[#indents + 1] = { line = l, indent = #line:gsub("\t", spaces):match("^%s*"), text = line }
    end
  end

  local ret = {} ---@type (Mini.ai.region | {indent: number})[]

  for i = 1, #indents do
    if i == 1 or indents[i - 1].indent < indents[i].indent then
      local from, to = i, i
      for j = i + 1, #indents do
        if indents[j].indent < indents[i].indent then
          break
        end
        to = j
      end
      from = ai_type == "a" and from > 1 and from - 1 or from
      to = ai_type == "a" and to < #indents and to + 1 or to
      ret[#ret + 1] = {
        indent = indents[i].indent,
        from = { line = indents[from].line, col = ai_type == "a" and 1 or indents[from].indent + 1 },
        to = { line = indents[to].line, col = #indents[to].text },
      }
    end
  end

  return ret
end

-- Taken from LazyVim.
local function ai_buffer(ai_type)
  local start_line, end_line = 1, vim.fn.line("$")
  if ai_type == "i" then
    -- Skip first and last blank lines for `i` textobject
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    -- Do nothing for buffer with all blanks
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end

  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

---@type LazyPluginSpec[]
return {
  {
    "echasnovski/mini.ai",
    event = "LazyFile",
    dependencies = { "which-key.nvim" },
    opts = function()
      local ai = require("mini.ai")

      return {
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
          i = ai_indent, -- indent
          g = ai_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
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

      local ret = { mode = { "o", "x" } }

      ---@type table<string, string>
      local mappings = vim.tbl_extend("force", {}, {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
      }, opts.mappings or {})
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub("^around_", ""):gsub("^inside_", "")
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == "i" then
            desc = desc:gsub(" with ws", "")
          end
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end

      require("which-key").add(ret, { notify = false })
    end,
  },
}
