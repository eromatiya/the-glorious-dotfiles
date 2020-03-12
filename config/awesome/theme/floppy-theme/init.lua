local filesystem = require('gears.filesystem')
local theme_dir = filesystem.get_configuration_dir() .. '/theme'

local theme = {}

theme.icons = theme_dir .. '/icons/'
theme.font = 'SF Pro Text Regular 10'
theme.font_bold = 'SF Pro Text Bold 10'


-- Colorscheme
theme.system_blue_dark = '#148eff' 
theme.system_blue_light = '#0070f5'
theme.system_brown_dark = '#b69872'
theme.system_brown_light = '#987a54'
theme.system_gray_dark = '#a2a2a7'
theme.system_gray_light = '#848489'
theme.system_green_dark = '#3ce155'
theme.system_green_light = '#1ec337'
theme.system_orange_dark = '#ffa914'
theme.system_orange_light = '#f58b00'
theme.system_pink_dark = '#ff4169'
theme.system_pink_light = '#f5234b'
theme.system_purple_dark = '#cc65ff'
theme.system_purple_light = '#9f4bc9'
theme.system_red_dark = '#ff5044'
theme.system_red_light = '#f53126'
theme.system_yellow_dark = '#fff414'
theme.system_yellow_light = '#f5c200'

-- Accent color
theme.accent = theme.system_blue_dark

-- Background color
theme.background = '#000000' .. '66'

-- Transparent
theme.transparent = '#00000000'

-- Awesome icon
theme.awesome_icon = theme.icons .. 'awesome.svg'

local awesome_overrides = function(theme) end

return {
	theme = theme,
 	awesome_overrides = awesome_overrides
}
