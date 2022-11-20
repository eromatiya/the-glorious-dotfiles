local repo = require("widget.toggles.repo")
local pl = require("pl.pretty")
local basic_toggle = require(... .. ".styles.basic")
local circular_toggle = require(... .. ".styles.circular")

---@type table<toggle_widgets, {basic : any, circular : any}>
local toggle_widgets = {
	bluetooth = {
		basic = basic_toggle(repo.bluetooth),
		circular = circular_toggle(repo.bluetooth),
	},
	airplane_mode = {
		basic = basic_toggle(repo.airplane_mode),
		circular = circular_toggle(repo.airplane_mode),
	},
	blue_light = {
		basic = basic_toggle(repo.blue_light),
		circular = circular_toggle(repo.blue_light),
	},
}

return toggle_widgets
