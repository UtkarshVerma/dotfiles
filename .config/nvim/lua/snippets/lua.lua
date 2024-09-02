return {
  s(
    "sti",
    fmta("-- stylua: ignore<multi>", {
      multi = d(1, function()
        local choices = { t(""), t(" start") }

        local cursor_line = unpack(vim.api.nvim_win_get_cursor(0))
        local lines = vim.api.nvim_buf_get_lines(0, 0, cursor_line - 1, false)
        for _, line in ipairs(lines) do
          if line:match("-- stylua: ignore start") then
            return sn(nil, t(" end\n"))
          end
        end

        return sn(nil, c(1, choices))
      end),
    })
  ),
}
