-- Credits: https://github.com/loctvl842/nvim/tree/master/lua/tvl/config/lualine

local icons = require("config").icons
local util = require("util")

local config = {
  float = true,
  separator_icon = { left = "█", right = "█" },
  thin_separator_icon = { left = " ", right = " " },
}

local hl_str = function(str, hl_cur, hl_after)
  if hl_after == nil then
    return "%#" .. hl_cur .. "#" .. str .. "%*"
  end
  return "%#" .. hl_cur .. "#" .. str .. "%*" .. "%#" .. hl_after .. "#"
end

local function hide_in_width()
  return vim.fn.winwidth(0) > 85
end

local function truncate(text, min_width)
  if string.len(text) > min_width then
    return string.sub(text, 1, min_width) .. "…"
  end
  return text
end

local function draw(groups)
  if groups == nil then
    return
  end
  for group, value in pairs(groups) do
    vim.api.nvim_set_hl(0, group, value)
  end
end

local function generate(palette)
  local float = config.float
  palette.yellow = util.get_highlight_value("String").foreground or "#ffff00"
  palette.white = util.get_highlight_value("Normal").foreground or "#ffffff"
  palette.red = util.get_highlight_value("DiagnosticError").foreground or "#ff0000"
  palette.orange = util.get_highlight_value("DiagnosticWarn").foreground or "#ff7700"
  palette.blue = util.get_highlight_value("DiagnosticHint").foreground or "#00ffff"
  palette.magenta = util.get_highlight_value("Statement").foreground or "#ff00ff"
  palette.green = util.get_highlight_value("healthSuccess").foreground or "#00ff00"
  return {
    SLGitIcon = {
      bg = float and palette.float_background or palette.statusbar_bg,
      fg = palette.green,
    },
    SLBranchName = {
      bg = float and palette.float_background or palette.statusbar_bg,
      fg = palette.green,
    },
    SLError = {
      bg = float and palette.editor_bg or palette.statusbar_bg,
      fg = palette.red,
    },
    SLWarning = {
      bg = float and palette.editor_bg or palette.statusbar_bg,
      fg = palette.orange,
    },
    SLInfo = {
      bg = float and palette.editor_bg or palette.statusbar_bg,
      fg = palette.blue,
    },
    SLDiffAdd = {
      bg = float and palette.editor_bg or palette.statusbar_bg,
      fg = palette.green,
    },
    SLDiffChange = {
      bg = float and palette.editor_bg or palette.statusbar_bg,
      fg = palette.yellow,
    },
    SLDiffDelete = {
      bg = float and palette.editor_bg or palette.statusbar_bg,
      fg = palette.red,
    },
    SLPosition = {
      bg = float and palette.float_background or palette.statusbar_bg,
      fg = palette.magenta,
    },
    SLFiletype = {
      bg = float and palette.float_background or palette.statusbar_bg,
      fg = palette.blue,
    },
    SLShiftWidth = {
      bg = float and palette.float_background or palette.statusbar_bg,
      fg = palette.yellow,
    },
    SLEncoding = {
      bg = float and palette.float_background or palette.statusbar_bg,
      fg = palette.green,
    },
    SLMode = {
      bg = float and palette.float_background or palette.statusbar_bg,
      fg = palette.green,
      bold = true,
    },
    SLSeparatorUnused = {
      bg = float and palette.float_background or palette.statusbar_bg,
      fg = palette.editor_bg,
    },
    SLSeparator = {
      bg = float and palette.editor_bg or palette.statusbar_bg,
      fg = float and palette.float_background or palette.statusbar_bg,
    },
    SLPadding = {
      bg = float and palette.editor_bg or palette.statusbar_bg,
      fg = palette.editor_bg,
    },
  }
end

local components = {}

local prev_branch = ""
local git_icon = hl_str(icons.git.logo, "SLGitIcon", "SLBranchName")
components.branch = {
  "branch",
  icons_enabled = false,
  icon = git_icon,
  colored = false,
  fmt = function(str)
    if vim.bo.filetype == "toggleterm" then
      str = prev_branch
    elseif str == "" or str == nil then
      return hl_str(config.separator_icon.left, "SLSeparator")
        .. hl_str("No VCS", "SLBranchName", "SLSeparator")
        .. hl_str(config.separator_icon.right, "SLSeparator", "SLSeparator")
    end
    prev_branch = str
    return hl_str(config.separator_icon.left, "SLSeparator")
      .. hl_str(git_icon, "SLGitIcon")
      .. hl_str(truncate(str, 10), "SLBranchName")
      .. hl_str(config.separator_icon.right, "SLSeparator", "SLSeparator")
  end,
}

components.position = function()
  -- print(vim.inspect(config.separator_icon))
  local current_line = vim.fn.line(".")
  local current_column = vim.fn.col(".")
  local left_sep = hl_str(config.separator_icon.left, "SLSeparator")
  local right_sep = hl_str(config.separator_icon.right, "SLSeparator", "SLSeparator")
  local str = "Ln " .. current_line .. ", Col " .. current_column
  return left_sep .. hl_str(str, "SLPosition", "SLPosition") .. right_sep
end

components.spaces = function()
  local left_sep = hl_str(config.separator_icon.left, "SLSeparator")
  local right_sep = hl_str(config.separator_icon.right, "SLSeparator", "SLSeparator")
  local str = "Spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  return left_sep .. hl_str(str, "SLShiftWidth", "SLShiftWidth") .. right_sep
end

components.diagnostics = function()
  local function nvim_diagnostic()
    local diagnostics = vim.diagnostic.get(0)
    local count = { 0, 0, 0, 0 }
    for _, diagnostic in ipairs(diagnostics) do
      count[diagnostic.severity] = count[diagnostic.severity] + 1
    end
    return count[vim.diagnostic.severity.ERROR],
      count[vim.diagnostic.severity.WARN],
      count[vim.diagnostic.severity.INFO],
      count[vim.diagnostic.severity.HINT]
  end

  local error_count, warn_count, info_count, hint_count = nvim_diagnostic()
  local error_hl = hl_str(icons.diagnostics.error .. " " .. error_count, "SLError", "SLError")
  local warn_hl = hl_str(icons.diagnostics.warn .. " " .. warn_count, "SLWarning", "SLWarning")
  local info_hl = hl_str(icons.diagnostics.info .. " " .. info_count, "SLInfo", "SLInfo")
  local hint_hl = hl_str(icons.diagnostics.hint .. " " .. hint_count, "SLInfo", "SLInfo")
  local left_sep = hl_str(config.thin_separator_icon.left, "SLSeparator")
  local right_sep = hl_str(config.thin_separator_icon.right, "SLSeparator", "SLSeparator")
  return left_sep .. error_hl .. " " .. warn_hl .. " " .. hint_hl .. right_sep
end

components.diff = {
  "diff",
  colored = true,
  diff_color = {
    added = "SLDiffAdd",
    modified = "SLDiffChange",
    removed = "SLDiffDelete",
  },
  symbols = {
    added = icons.git.added .. " ",
    modified = icons.git.modified .. " ",
    removed = icons.git.removed .. " ",
  }, -- changes diff symbols
  fmt = function(str)
    if str == "" then
      return ""
    end
    local left_sep = hl_str(config.thin_separator_icon.left, "SLSeparator")
    local right_sep = hl_str(config.thin_separator_icon.right, "SLSeparator", "SLSeparator")
    return left_sep .. str .. right_sep
  end,
  cond = hide_in_width,
}

components.mode = {
  "mode",
  fmt = function(str)
    local left_sep = hl_str(config.separator_icon.left, "SLSeparator", "SLPadding")
    local right_sep = hl_str(config.separator_icon.right, "SLSeparator", "SLPadding")
    return left_sep .. hl_str(str, "SLMode") .. right_sep
  end,
}

local prev_filetype = ""
components.filetype = {
  "filetype",
  icons_enabled = false,
  icons_only = false,
  fmt = function(str)
    local ui_filetypes = {
      "help",
      "packer",
      "neogitstatus",
      "NvimTree",
      "Trouble",
      "lir",
      "Outline",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "neo-tree",
      "",
    }
    local filetype_str = ""

    if str == "toggleterm" then
      -- 
      filetype_str = "ToggleTerm " .. vim.api.nvim_buf_get_var(0, "toggle_number")
    elseif str == "TelescopePrompt" then
      filetype_str = " "
    elseif str == "neo-tree" or str == "neo-tree-popup" then
      if prev_filetype == "" then
        return
      end
      filetype_str = prev_filetype
    elseif str == "help" then
      filetype_str = " "
    elseif vim.tbl_contains(ui_filetypes, str) then
      return
    else
      prev_filetype = str
      filetype_str = str
    end
    local left_sep = hl_str(config.separator_icon.left, "SLSeparator")
    local right_sep = hl_str(config.separator_icon.right, "SLSeparator", "SLSeparator")
    -- Upper case first character
    filetype_str = filetype_str:gsub("%a", string.upper, 1)
    local filetype_hl = hl_str(filetype_str, "SLFiletype", "SLFiletype")
    return left_sep .. filetype_hl .. right_sep
  end,
}

local function configure(opts)
  local statusline_hl = util.get_highlight_value("StatusLine")
  local palette = {
    float_background = util.get_highlight_value("Pmenu").background,
    editor_bg = util.get_highlight_value("Normal").background or "NONE",
    statusbar_bg = statusline_hl.background or "#000000",
    statusbar_fg = statusline_hl.foreground or "#505050",
  }
  local groups = generate(palette)
  draw(groups)

  -- Clear theme if float ortherwhise, make it auto
  opts.options.theme = config.float and { normal = { c = { bg = palette.editor_bg } } } or "auto"

  return opts
end

return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        icons_enabled = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "dashboard", "lazy" },
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          -- winbar = 100,
        },
      },
      sections = {
        lualine_a = { components.branch },
        lualine_b = { components.diagnostics },
        lualine_c = {},
        lualine_x = { components.diff },
        lualine_y = { components.position, components.filetype },
        lualine_z = { components.spaces, components.mode },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    },
    config = function(_, opts)
      local lualine = require("lualine")
      lualine.setup(configure(opts))

      -- Reload on colorscheme change
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          lualine.setup(configure(opts))
        end,
      })
    end,
  },
}
