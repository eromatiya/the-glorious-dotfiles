local gears = require("gears")
local awful = require("awful")
--- @type {["floppy"]: function, ["gnawesome"]: function}
local control_center_button = screen.clock_widget:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					awful.screen.focused().central_panel:toggle()
				end
			)
		)
	)

local buttons = {
	["floppy"] = 	["gnawesome"] = "string",
}
