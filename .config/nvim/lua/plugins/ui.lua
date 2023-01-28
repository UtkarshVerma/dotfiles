return {
  { "rcarriga/nvim-notify", enabled = false },
  { "echasnovski/mini.indentscope", enabled = false },
  { "folke/noice.nvim", enabled = false },
  { "SmiteshP/nvim-navic", enabled = false },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts)
      return vim.tbl_deep_extend("force", opts, {
        char = "▏",
        context_char = "▏",
        char_priority = 30,
        show_current_context = true,
      })
    end,
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "BufReadPost",
    dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
    init = function()
      vim.o.foldcolumn = "0" -- Don't show the foldcolumn
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },
  {
    "stevearc/vim-arduino",
    ft = "arduino",
    keys = {
      { "<leader>aa", "<cmd>ArduinoAttach<CR>", desc = "Attach Arduino" },
      { "<leader>am", "<cmd>ArduinoVerify<CR>", desc = "Verify Code" },
      { "<leader>au", "<cmd>ArduinoUpload<CR>", desc = "Upload Code" },
      { "<leader>ad", "<cmd>ArduinoUploadAndSerial<CR>", desc = "Upload and Debug" },
      { "<leader>ab", "<cmd>ArduinoChooseBoard<CR>", desc = "Choose Arduino Board" },
      { "<leader>ap", "<cmd>ArduinoChooseProgrammer<CR>", desc = "Choose Arduino Programmer" },
    },
    config = function(_, _)
      vim.g.arduino_dir = "/usr/share/arduino/"
      vim.g.arduino_home_dir = os.getenv("ARDUINO_DIRECTORIES_DATA") or "~/.arduino15"
    end,
  },
}
