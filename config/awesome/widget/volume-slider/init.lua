local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local beautiful = require("beautiful")
local spawn = awful.spawn
local dpi = beautiful.xresources.apply_dpi
local icons = require("theme.icons")
local icon_class = require("widget.meters.entities.icon")
local name_class = require("widget.meters.entities.name")

local height_map = {
	floppy = dpi(2),
}
local handle_width_map = {
	floppy = dpi(15),
}

local action_name = name_class:new("Volume", _, _)
local icon = icon_class:new(icons.volume, _, true, _)

local slider = wibox.widget({
	nil,
	{
		id = "volume_slider",
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

local volume_slider = slider.volume_slider

volume_slider:connect_signal("property::value", function()
	local volume_level = volume_slider:get_value()

	spawn("amixer -D pulse sset Master " .. volume_level .. "%", false)

	-- Update volume osd
	awesome.emit_signal("module::volume_osd", volume_level)
end)

volume_slider:buttons(gears.table.join(
	awful.button({}, 4, nil, function()
		if volume_slider:get_value() > 100 then
			volume_slider:set_value(100)
			return
		end
		volume_slider:set_value(volume_slider:get_value() + 5)
	end),
	awful.button({}, 5, nil, function()
		if volume_slider:get_value() < 0 then
			volume_slider:set_value(0)
			return
		end
		volume_slider:set_value(volume_slider:get_value() - 5)
	end)
))

local update_slider = function()
	awful.spawn.easy_async_with_shell([[bash -c "amixer -D pulse sget Master"]], function(stdout)
		local volume = string.match(stdout, "(%d?%d?%d)%%")
		volume_slider:set_value(tonumber(volume))
	end)
end

-- Update on startup
update_slider()

local action_jump = function()
	local sli_value = volume_slider:get_value()
	local new_value = 0

	if sli_value >= 0 and sli_value < 50 then
		new_value = 50
	elseif sli_value >= 50 and sli_value < 100 then
		new_value = 100
	else
		new_value = 0
	end
	volume_slider:set_value(new_value)
end

icon:buttons(awful.util.table.join(awful.button({}, 1, nil, function()
	action_jump()
end)))

-- The emit will come from the global keybind
awesome.connect_signal("widget::volume", function()
	update_slider()
end)

-- The emit will come from the OSD
awesome.connect_signal("widget::volume:update", function(value)
	volume_slider:set_value(tonumber(value))
end)

local volume_setting = wibox.widget({
	layout = wibox.layout.fixed.vertical,
	forced_height = dpi(48),
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

return volume_setting
