local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local clickable_container = require("widget.clickable-container")
local icon_class = require("widget.meters.entities.icon")

local action_name = wibox.widget({
	text = "Brightness",
	font = "Inter Bold 10",
	align = "left",
	widget = wibox.widget.textbox,
})

local icon = icon_class:new(icons.brightness, _, true, _)
local height_map = {
	floppy = dpi(2),
}
local handle_width_map = {
	floppy = dpi(15),
}

local slider = wibox.widget({
	nil,
	{
		id = "brightness_slider",
		bar_shape = gears.shape.rounded_rect,
		bar_height = height_map[THEME] or dpi(24),
		bar_color = "#ffffff20",
		bar_active_color = "#f2f2f2EE",
		handle_color = "#ffffff",
		handle_shape = gears.shape.circle,
		handle_width = handle_width_map[THEME] or dpi(24),
		handle_border_color = "#00000012",
		handle_border_width = dpi(1),
		maximum = 100,
		widget = wibox.widget.slider,
	},
	nil,
	expand = "none",
	forced_height = dpi(24),
	layout = wibox.layout.align.vertical,
})

local brightness_slider = slider.brightness_slider

brightness_slider:connect_signal("property::value", function()
	local brightness_level = brightness_slider:get_value()

	spawn("light -S " .. math.max(brightness_level, 5), false)

	-- Update brightness osd
	awesome.emit_signal("module::brightness_osd", brightness_level)
end)

brightness_slider:buttons(gears.table.join(
	awful.button({}, 4, nil, function()
		if brightness_slider:get_value() > 100 then
			brightness_slider:set_value(100)
			return
		end
		brightness_slider:set_value(brightness_slider:get_value() + 5)
	end),
	awful.button({}, 5, nil, function()
		if brightness_slider:get_value() < 0 then
			brightness_slider:set_value(0)
			return
		end
		brightness_slider:set_value(brightness_slider:get_value() - 5)
	end)
))

local update_slider = function()
	awful.spawn.easy_async_with_shell("light -G", function(stdout)
		local brightness = string.match(stdout, "(%d+)")
		brightness_slider:set_value(tonumber(brightness))
	end)
end

-- Update on startup
update_slider()

local action_jump = function()
	local sli_value = brightness_slider:get_value()
	local new_value = 0

	if sli_value >= 0 and sli_value < 50 then
		new_value = 50
	elseif sli_value >= 50 and sli_value < 100 then
		new_value = 100
	else
		new_value = 0
	end
	brightness_slider:set_value(new_value)
end

icon:buttons(awful.util.table.join(awful.button({}, 1, nil, function()
	action_jump()
end)))

-- The emit will come from the global keybind
awesome.connect_signal("widget::brightness", function()
	update_slider()
end)

-- The emit will come from the OSD
awesome.connect_signal("widget::brightness:update", function(value)
	brightness_slider:set_value(tonumber(value))
end)

local brightness_setting = wibox.widget({
	layout = wibox.layout.fixed.vertical,
	spacing = dpi(5),
	action_name,
	{
		layout = wibox.layout.fixed.horizontal,
		spacing = dpi(5),
		{
			layout = wibox.layout.align.vertical,
			expand = "none",
			nil,
			{
				layout = wibox.layout.fixed.horizontal,
				forced_height = dpi(24),
				forced_width = dpi(24),
				icon,
			},
			nil,
		},
		slider,
	},
})

return brightness_setting
