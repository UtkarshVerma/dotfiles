---@module "oil"
---@class plugins.oil.config: oil.SetupOpts

---@type LazyPluginSpec[]
return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-web-devicons" },
    cmd = "Oil",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    init = function(_)
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = vim.schedule_wrap(function(data)
          if data.file ~= "" and vim.fn.isdirectory(data.file) ~= 0 then
            require("oil").open(data.file)
          end
        end),
      })
    end,
    ---@type plugins.oil.config
    opts = {},
  },
}
