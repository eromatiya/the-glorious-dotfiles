local repo = require(... .. ".repo")
local pl = require("pl.pretty")
local basic_toggle = require(... .. ".styles.basic")
local get_basic_toggles = function()
	for i, v in pairs(repo) do
		repo[i] = basic_toggle(v)
	end
	return repo
end

---@type toggle_widgets
local toggle_widgets = get_basic_toggles()
print(toggle_widgets["airplane_mode"])

return toggle_widgets
