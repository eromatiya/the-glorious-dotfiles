local repo = require("widget.toggles.repo")
local basic_toggle = require(... .. ".styles.basic")
local circular_toggle = require(... .. ".styles.circular")

---@type table<toggle_widgets, {basic : any, circular : any}>
local toggle_widgets = {
  -- bluetooth = {
  -- 	basic = basic_toggle(repo.bluetooth),
  -- 	circular = circular_toggle(repo.bluetooth),
  -- },
  -- airplane_mode = {
  -- 	basic = basic_toggle(repo.airplane_mode),
  -- 	circular = circular_toggle(repo.airplane_mode),
  -- },
  -- blue_light = {
  -- 	basic = basic_toggle(repo.blue_light),
  -- 	circular = circular_toggle(repo.blue_light),
  -- },
}
for k, v in pairs(repo) do
  toggle_widgets[k] = {
    basic = basic_toggle(v),
    circular = circular_toggle(v),
  }
end

return toggle_widgets
