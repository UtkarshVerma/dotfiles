---@class config.icons
local M = {
  misc = {
    File = " ",
    Files = " ",
    Reload = " ",
    Search = " ",
    Lazy = "󰒲 ",
    Modified = "",
    Clock = " ",
    Server = " ",
    Quit = " ",
    RootDir = "󱉭",
    FolderClosed = "",
    FolderOpen = "",
    FolderEmptyOpen = "",
    ChevronRight = "",
    ChevronDown = "",
  },
  ---@type table<string, string|string[]>
  dap = {
    Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
    Breakpoint = " ",
    BreakpointCondition = " ",
    BreakpointRejected = { " ", "DiagnosticError" },
    LogPoint = ".>",
  },
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  gitsigns = {
    Add = "┃",
    Change = "┋",
    Delete = "",
    TopDelete = "",
    ChangeDelete = "┃",
    Untracked = "┃",
  },
  ---@type table<util.ui.border.type, util.ui.border.chars>
  borders = {
    thin = {
      top = "▔",
      right = "▕",
      bottom = "▁",
      left = "▏",
      top_left = "🭽",
      top_right = "🭾",
      bottom_right = "🭿",
      bottom_left = "🭼",
    },
    empty = {
      top = " ",
      right = " ",
      bottom = " ",
      left = " ",
      top_left = " ",
      top_right = " ",
      bottom_right = " ",
      bottom_left = " ",
    },
    thick = {
      top = "▄",
      right = "█",
      bottom = "▀",
      left = "█",
      top_left = "▄",
      top_right = "▄",
      bottom_right = "▀",
      bottom_left = "▀",
    },
  },
  indent = {
    inactive = "▏",
    active = "▏",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
    renamed = "➜",
    untracked = "",
    ignored = " ",
    unstaged = "U",
    staged = " ",
    conflict = "",
    deleted = " ",
    logo = "󰊢 ",
  },
  kinds = {
    Array = " ",
    Boolean = " ",
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Macro = "",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = " ",
    Number = " ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
  },
}

return M
