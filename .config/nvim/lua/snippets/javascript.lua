---@diagnostic disable: undefined-global

return {
  s(
    "fn",
    fmta(
      [[
function <name>(<args>) {
	<body>
}
]],
      {
        name = i(1),
        args = i(2),
        body = i(0),
      }
    )
  ),
}
