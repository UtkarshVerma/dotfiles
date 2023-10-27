local M = {
  version = 2,
  data = {
    version = nil, ---@type string?
    news = {}, ---@type table<string, string>
    extras = {}, ---@type string[]
  },
}

function M.load()
  local path = vim.fn.stdpath("config") .. "/editor.json"
  local f = io.open(path, "r")
  if f then
    local data = f:read("*a")
    f:close()
    local ok, json = pcall(vim.json.decode, data, { luanil = { object = true, array = true } })
    if ok then
      M.data = vim.tbl_deep_extend("force", M.data, json or {})
    end
  end
end

return M
