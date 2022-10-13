local gtable = require("gears.table")
local default_theme = require("theme.floppy.default-theme")
-- PICK THEME HERE
local theme = require("theme.floppy.floppy-theme")

local final_theme = {}
gtable.crush(final_theme, default_theme.theme)
gtable.crush(final_theme, theme.theme)
default_theme.awesome_overrides(final_theme)
theme.awesome_overrides(final_theme)
print(final_theme.layout_max)

return final_theme
