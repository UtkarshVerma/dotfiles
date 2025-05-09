return {
  s(
    "if",
    fmt(
      [[
if ({cond}) begin
  {body}
end
]],
      {
        cond = i(1),
        body = i(0),
      }
    )
  ),

  s(
    "ife",
    fmt(
      [[
  if ({cond}) begin
    {if_body}
  end
  else begin
    {else_body}
  end
  ]],
      {
        cond = i(1),
        if_body = i(2),
        else_body = i(3),
      }
    )
  ),

  s(
    "eif",
    fmt(
      [[
  else if ({cond}) begin
    {body}
  end
  ]],
      {
        cond = i(1),
        body = i(0),
      }
    )
  ),

  s(
    "el",
    fmt(
      [[
  else begin
    {body}
  end
  ]],
      {
        body = i(0),
      }
    )
  ),

  s(
    "wh",
    fmt(
      [[
  while ({cond}) begin
    {body}
  end
  ]],
      {
        cond = i(1),
        body = i(0),
      }
    )
  ),

  s(
    "repeat",
    fmt(
      [[
  repeat ({count}) begin
    {body}
  end
  ]],
      {
        count = i(1),
        body = i(0),
      }
    )
  ),

  s(
    "case",
    fmt(
      [[
  case ({expr})
    {val}: begin
      {body}
    end
  default: begin
    {default_body}
  end
  endcase
  ]],
      {
        expr = i(1, "variable"),
        val = i(2, "value"),
        body = i(3),
        default_body = i(4),
      }
    )
  ),

  s(
    "casez",
    fmt(
      [[
  casez ({expr})
    {val}: begin
      {body}
    end
  default: begin
    {default_body}
  end
  endcase
  ]],
      {
        expr = i(1, "variable"),
        val = i(2, "value"),
        body = i(3),
        default_body = i(4),
      }
    )
  ),

  s(
    "al",
    fmt(
      [[
  always @({sensitivity}) begin
    {body}
  end
  ]],
      {
        sensitivity = i(1, "Sensitive list"),
        body = i(0),
      }
    )
  ),

  s(
    "modu",
    fmt(
      [[
  module {name} (
    {ports}
  );
    {body}
  endmodule
  ]],
      {
        name = i(1, "FILENAME"),
        ports = i(2),
        body = i(0),
      }
    )
  ),

  s(
    "for",
    fmt(
      [[
  for (int {iter} = 0; {iter} < {count}; {iter}{step}) begin
    {body}
  end
  ]],
      {
        iter = i(2, "i"),
        count = i(1, "count"),
        step = i(3, "++"),
        body = i(4),
      }
    )
  ),

  s(
    "forev",
    fmt(
      [[
  forever begin
    {body}
  end
  ]],
      {
        body = i(0),
      }
    )
  ),

  s(
    "fun",
    fmt(
      [[
  function {ret} {name}({args});
    {body}
  endfunction: {name}
  ]],
      {
        ret = i(1, "void"),
        name = i(2, "name"),
        args = i(3),
        body = i(0),
      }
    )
  ),

  s(
    "task",
    fmt(
      [[
  task {name}({args});
    {body}
  endtask: {name}
  ]],
      {
        name = i(1, "name"),
        args = i(2),
        body = i(0),
      }
    )
  ),

  s(
    "ini",
    fmt(
      [[
  initial begin
    {body}
  end
  ]],
      {
        body = i(0),
      }
    )
  ),

  s(
    "tdsp",
    fmt(
      [[
  typedef struct packed {{
    int {data};
  }} {name};
  ]],
      {
        data = i(2, "data"),
        name = i(1, "name"),
      }
    )
  ),

  s(
    "tde",
    fmt(
      [[
  typedef enum {type} {{
    {vals}
  }} {name};
  ]],
      {
        type = i(2, "logic[15:0]"),
        vals = i(3, "REG = 16'h0000"),
        name = i(1, "my_dest_t"),
      }
    )
  ),
}
