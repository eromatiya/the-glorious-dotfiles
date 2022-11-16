local icons = require("theme.icons")
local slider_class = require("widget.meters.entities.slider")
local icon_class = require("widget.meters.entities.icon")
local name_class = require("widget.meters.entities.name")
local meter = require("widget.meters.entities.meter")
local meter_repo = require(... .. ".repo")

-- 🔧 TODO: complete meter classes for refactoring
local themes_without_icon_bg = {
	floppy = true,
}

---@see creting a meter widget utilizing domains
---@param args meter_args
local meter_factory = function(args)
	local meter_name = name_class:new(args.name, _, _)
	local slider = slider_class:new(args.slider_id, args.update_script, args.update_interval, args.update_callback)
	--- 🔧 change to more miningful icon
	local meter_icon = icon_class:new(args.icon, args.icon_margins, args.clickable, not themes_without_icon_bg[THEME])
	return meter(meter_name, meter_icon, slider)
end
---@param name "cpu" | "ram" | "temperature" | "disk" | "network"
local create_widget = function(name)
	local meter_args = meter_repo[name]
	return meter_factory(meter_args)
end
return create_widget
