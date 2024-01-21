return {
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    keys = {
      {
        "<leader>ut",
        function()
          local util = require("util")
          local tsc = require("treesitter-context")
          tsc.toggle()

          if util.get_upvalue(tsc.toggle, "enabled") then
            util.log.info("Enabled treesitter context", "Option")
          else
            util.log.warn("Disabled treesitter context", "Option")
          end
        end,
        desc = "Toggle treesitter context",
      },
    },
    opts = {
      mode = "cursor",
      max_lines = 2,
    },
  },

  { "JoosepAlviste/nvim-ts-context-commentstring" },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",

    -- NOTE: https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/513
    commit = "73e44f43c70289c70195b5e7bc6a077ceffddda4",

    config = function()
      -- When in diff mode, we want to use the default
      -- vim text objects c & C instead of the treesitter ones.
      local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
      local configs = require("nvim-treesitter.configs")
      for name, fn in pairs(move) do
        if name:find("goto") == 1 then
          move[name] = function(q, ...)
            if vim.wo.diff then
              local config = configs.get_module("textobjects.move")[name] ---@type table<string,string>
              for key, query in pairs(config or {}) do
                if q == query and key:find("[%]%[][cC]") then
                  vim.cmd("normal! " .. key)
                  return
                end
              end
            end
            return fn(q, ...)
          end
        end
      end
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter.configs",
    build = ":TSUpdate",
    event = "LazyFile",
    dependencies = { "nvim-treesitter-textobjects" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>", desc = "Decrement selection", mode = "x" },
    },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = {},
      context_commentstring = {},
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
        },
      },
    },
  },
}
