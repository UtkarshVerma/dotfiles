local status_ok, autopairs = pcall(require, "nvim-autopairs")
if not status_ok then
    return
end

autopairs.setup {
    check_ts = true,
    ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
    },
}

local cmp_status_ok, cmp = pcall(require, "cmp")
if cmp_status_ok then
    local autopairs_cmp = require "nvim-autopairs.completion.cmp"
    cmp.event:on("confirm_done", autopairs_cmp.on_confirm_done {
        map_char = {
            tex = ""
        }
    })
end
