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
  palette.yellow = util.ui.get_hl("String").fg or "#ffff00"
  palette.white = util.ui.get_hl("Normal").fg or "#ffffff"
  palette.red = util.ui.get_hl("DiagnosticError").fg or "#ff0000"
  palette.orange = util.ui.get_hl("DiagnosticWarn").fg or "#ff7700"
  palette.blue = util.ui.get_hl("DiagnosticHint").fg or "#00ffff"
  palette.magenta = util.ui.get_hl("Statement").fg or "#ff00ff"
  palette.green = util.ui.get_hl("healthSuccess").fg or "#00ff00"
  return {
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

components.branch = {
  "branch",
  icons_enabled = false,
  colored = false,
  fmt = function(str)
    local icon = icons.git.logo

    if str == "" or str == nil then
      str = "No VCS"
      icon = ""
    end

    return hl_str(config.separator_icon.left, "SLSeparator", "SLBranchName")
      .. table.concat({ icon, truncate(str, 10) }, " ")
      .. hl_str(config.separator_icon.right, "SLSeparator", "SLSeparator")
  end,
}

components.position = function()
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

  local indent_type = vim.api.nvim_buf_get_option(0, "expandtab") and "Spaces" or "Tab"
  local indent_width = vim.api.nvim_buf_get_option(0, "shiftwidth")

  local str = string.format("%s: %d", indent_type, indent_width)
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
    local filetype_hl = hl_str(filetype_str, "SLFiletype", "SLFiletype")
    return left_sep .. filetype_hl .. right_sep
  end,
}

local function configure(opts)
  local statusline_hl = util.ui.get_hl("StatusLine")
  local palette = {
    float_background = util.ui.get_hl("Pmenu").bg,
    editor_bg = util.ui.get_hl("Normal").bg or "NONE",
    statusbar_bg = statusline_hl.bg or "#000000",
    statusbar_fg = statusline_hl.fg or "#505050",
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
