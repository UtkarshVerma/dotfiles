function Manager:render(area)
	local chunks = self:layout(area)

	local function bar(c, x, y)
		x, y = math.max(0, x), math.max(0, y)
		return ui.Bar(ui.Rect({ x = x, y = y, w = ya.clamp(0, area.w - x, 1), h = math.min(1, area.h) }), ui.Bar.TOP)
			:symbol(c)
	end

	return ya.flat({
		-- Borders
		ui.Bar(chunks[1], ui.Bar.RIGHT):symbol(THEME.manager.border_symbol):style(THEME.manager.border_style),
		ui.Bar(chunks[3], ui.Bar.LEFT):symbol(THEME.manager.border_symbol):style(THEME.manager.border_style),

		-- Parent
		Parent:render(chunks[1]:padding(ui.Padding.x(1))),
		-- Current
		Current:render(chunks[2]),
		-- Preview
		Preview:render(chunks[3]:padding(ui.Padding.x(1))),
	})
end

function Header:host()
	return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end

function Header:render(area)
	local chunks = self:layout(area)

	local left = ui.Line({ self:host(), self:cwd() })
	local right = ui.Line({ self:tabs() })
	return {
		ui.Paragraph(chunks[1], { left }),
		ui.Paragraph(chunks[2], { right }):align(ui.Paragraph.RIGHT),
	}
end

function Status:owner()
	local h = cx.active.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line({})
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	})
end

function Status:render(area)
	self.area = area

	local left = ui.Line({ self:mode(), self:size(), self:name() })
	local right = ui.Line({ self:owner(), self:permissions(), self:percentage(), self:position() })
	return {
		ui.Paragraph(area, { left }),
		ui.Paragraph(area, { right }):align(ui.Paragraph.RIGHT),
		table.unpack(Progress:render(area, right:width())),
	}
end
