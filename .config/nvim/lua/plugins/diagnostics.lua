vim.g.diagnostics_enabled = true

local diagnostics = {
  off = {
    underline = true,
    virtual_text = false,
    signs = false,
    update_in_insert = false,
  },
  on = {
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    }, -- disable virtual text
    virtual_lines = false,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      -- border = "rounded",
      -- border = Util.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
      source = "always",
      header = "",
      prefix = "",
    },
  },
}

vim.api.nvim_create_user_command("ToggleDiagnostics", function()
  if vim.g.diagnostics_enabled then
    vim.diagnostic.config(diagnostics["off"])
    vim.g.diagnostics_enabled = false
  else
    vim.diagnostic.config(diagnostics["on"])
    vim.g.diagnostics_enabled = true
  end
end, { nargs = 0 })

return {
  {
    "null-ls.nvim",
    dependencies = {
      "typescript.nvim",
    },
    opts = function(_, opts)
      local nls = require("null-ls")

      return vim.tbl_deep_extend("force", opts, {
        sources = {
          nls.builtins.code_actions.eslint_d,
          nls.builtins.code_actions.shellcheck,
          require("typescript.extensions.null-ls.code-actions"),

          nls.builtins.diagnostics.alex,
          nls.builtins.diagnostics.cmake_lint,
          nls.builtins.diagnostics.markdownlint,
          nls.builtins.diagnostics.ruff.with({ extra_args = { "--line-length", 79 } }),
          nls.builtins.diagnostics.yamllint.with({
            extra_args = {
              "-d",
              "{extends: default, rules: {document-start: {present: false}, line-length: {max: 79}}}",
            },
          }),
        },
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
