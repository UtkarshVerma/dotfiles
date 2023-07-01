return {
  {
    "null-ls.nvim",
    dependencies = {
      "typescript.nvim",
    },
    opts = function(_, opts)
      local nls = require("null-ls")

      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        nls.builtins.code_actions.shellcheck,
        require("typescript.extensions.null-ls.code-actions"),

        nls.builtins.diagnostics.cmake_lint,
        nls.builtins.diagnostics.ruff.with({ extra_args = { "--line-length", vim.o.colorcolumn - 1 } }),
        nls.builtins.diagnostics.yamllint.with({
          extra_args = {
            "-d",
            string.format(
              "{extends: default, rules: {document-start: disable, line-length: {max: %d}}}",
              vim.o.colorcolumn - 1
            ),
          },
        }),
      })
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            vim.cmd.cprev()
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            vim.cmd.cnext()
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
}
