local gears = require('gears')
local beautiful = require('beautiful')

local filesystem = gears.filesystem
local dpi = beautiful.xresources.apply_dpi
local gtk_variable = beautiful.gtk.get_theme_variables

local theme_dir = filesystem.get_configuration_dir() .. '/theme'
local titlebar_theme = 'stoplight'
local titlebar_icon_path = theme_dir .. '/icons/titlebar/' .. titlebar_theme .. '/'
local tip = titlebar_icon_path

-- Create theme table
local theme = {}

-- Font
theme.font = 'Inter Regular 10'
theme.font_bold = 'Inter Bold 10'

-- Menu icon theme
theme.icon_theme = 'Tela-blue-dark'

local awesome_overrides = function(theme)

	theme.dir = theme_dir
	theme.icons = theme_dir .. '/icons/'

	-- Default wallpaper path
	theme.wallpaper = theme.dir .. '/wallpapers/morning-wallpaper.jpg'

	-- Default font
	theme.font = 'Inter Regular 10'

	-- Foreground
	theme.fg_normal = '#ffffffde'
	theme.fg_focus = '#e4e4e4'
	theme.fg_urgent = '#CC9393'

	theme.bg_normal = theme.background
	theme.bg_focus = '#5a5a5a'
	theme.bg_urgent = '#3F3F3F'

	-- System tray
	theme.bg_systray = theme.background
	theme.systray_icon_spacing = dpi(16)

	-- Titlebar
	theme.titlebar_size = dpi(34)
	theme.titlebar_bg_focus = gtk_variable().bg_color:sub(1,7) .. '66'
	theme.titlebar_bg_normal = gtk_variable().base_color:sub(1,7) .. '66'
	theme.titlebar_fg_focus = gtk_variable().fg_color .. '00'
	theme.titlebar_fg_normal = gtk_variable().fg_color .. '00'

	-- Close Button
	theme.titlebar_close_button_normal = tip .. 'close_normal.svg'
	theme.titlebar_close_button_focus  = tip .. 'close_focus.svg'

	-- Minimize Button
	theme.titlebar_minimize_button_normal = tip .. 'minimize_normal.svg'
	theme.titlebar_minimize_button_focus  = tip .. 'minimize_focus.svg'

	-- Ontop Button
	theme.titlebar_ontop_button_normal_inactive = tip .. 'ontop_normal_inactive.svg'
	theme.titlebar_ontop_button_focus_inactive  = tip .. 'ontop_focus_inactive.svg'
	theme.titlebar_ontop_button_normal_active = tip .. 'ontop_normal_active.svg'
	theme.titlebar_ontop_button_focus_active  = tip .. 'ontop_focus_active.svg'

	-- Sticky Button
	theme.titlebar_sticky_button_normal_inactive = tip .. 'sticky_normal_inactive.svg'
	theme.titlebar_sticky_button_focus_inactive  = tip .. 'sticky_focus_inactive.svg'
	theme.titlebar_sticky_button_normal_active = tip .. 'sticky_normal_active.svg'
	theme.titlebar_sticky_button_focus_active  = tip .. 'sticky_focus_active.svg'

	-- Floating Button
	theme.titlebar_floating_button_normal_inactive = tip .. 'floating_normal_inactive.svg'
	theme.titlebar_floating_button_focus_inactive  = tip .. 'floating_focus_inactive.svg'
	theme.titlebar_floating_button_normal_active = tip .. 'floating_normal_active.svg'
	theme.titlebar_floating_button_focus_active  = tip .. 'floating_focus_active.svg'

	-- Maximized Button
	theme.titlebar_maximized_button_normal_inactive = tip .. 'maximized_normal_inactive.svg'
	theme.titlebar_maximized_button_focus_inactive  = tip .. 'maximized_focus_inactive.svg'
	theme.titlebar_maximized_button_normal_active = tip .. 'maximized_normal_active.svg'
	theme.titlebar_maximized_button_focus_active  = tip .. 'maximized_focus_active.svg'

	-- Hovered Close Button
	theme.titlebar_close_button_normal_hover = tip .. 'close_normal_hover.svg'
	theme.titlebar_close_button_focus_hover  = tip .. 'close_focus_hover.svg'

	-- Hovered Minimize Buttin
	theme.titlebar_minimize_button_normal_hover = tip .. 'minimize_normal_hover.svg'
	theme.titlebar_minimize_button_focus_hover  = tip .. 'minimize_focus_hover.svg'

	-- Hovered Ontop Button
	theme.titlebar_ontop_button_normal_inactive_hover = tip .. 'ontop_normal_inactive_hover.svg'
	theme.titlebar_ontop_button_focus_inactive_hover  = tip .. 'ontop_focus_inactive_hover.svg'
	theme.titlebar_ontop_button_normal_active_hover = tip .. 'ontop_normal_active_hover.svg'
	theme.titlebar_ontop_button_focus_active_hover  = tip .. 'ontop_focus_active_hover.svg'

	-- Hovered Sticky Button
	theme.titlebar_sticky_button_normal_inactive_hover = tip .. 'sticky_normal_inactive_hover.svg'
	theme.titlebar_sticky_button_focus_inactive_hover  = tip .. 'sticky_focus_inactive_hover.svg'
	theme.titlebar_sticky_button_normal_active_hover = tip .. 'sticky_normal_active_hover.svg'
	theme.titlebar_sticky_button_focus_active_hover  = tip .. 'sticky_focus_active_hover.svg'

	-- Hovered Floating Button
	theme.titlebar_floating_button_normal_inactive_hover = tip .. 'floating_normal_inactive_hover.svg'
	theme.titlebar_floating_button_focus_inactive_hover  = tip .. 'floating_focus_inactive_hover.svg'
	theme.titlebar_floating_button_normal_active_hover = tip .. 'floating_normal_active_hover.svg'
	theme.titlebar_floating_button_focus_active_hover  = tip .. 'floating_focus_active_hover.svg'

	-- Hovered Maximized Button
	theme.titlebar_maximized_button_normal_inactive_hover = tip .. 'maximized_normal_inactive_hover.svg'
	theme.titlebar_maximized_button_focus_inactive_hover  = tip .. 'maximized_focus_inactive_hover.svg'
	theme.titlebar_maximized_button_normal_active_hover = tip .. 'maximized_normal_active_hover.svg'
	theme.titlebar_maximized_button_focus_active_hover  = tip .. 'maximized_focus_active_hover.svg'

	-- UI Groups
	theme.groups_title_bg = '#ffffff' .. '15'
	theme.groups_bg = '#ffffff' .. '10'
	theme.groups_radius = dpi(16)

	-- UI events
	theme.leave_event = transparent
	theme.enter_event = '#ffffff' .. '10'
	theme.press_event = '#ffffff' .. '15'
	theme.release_event = '#ffffff' .. '10'

	-- Client Decorations

	-- Borders
	theme.border_focus = gtk_variable().bg_color
	theme.border_normal = gtk_variable().base_color
	theme.border_marked = '#CC9393'
	theme.border_width = dpi(0)
	theme.border_radius = dpi(12)

	-- Decorations
	theme.client_radius = dpi(9)
	theme.useless_gap = dpi(4)

	-- Menu
	theme.menu_font = 'Inter Regular 11'
	theme.menu_submenu = '' -- ➤

	theme.menu_height = dpi(34)
	theme.menu_width = dpi(200)
	theme.menu_border_width = dpi(20)
	theme.menu_bg_focus = theme.accent .. 'CC'

	theme.menu_bg_normal =  theme.background:sub(1,7) .. '33'
	theme.menu_fg_normal = '#ffffff'
	theme.menu_fg_focus = '#ffffff'
	theme.menu_border_color = theme.background:sub(1,7) .. '5C'

	-- Tooltips

	theme.tooltip_bg = theme.background
	theme.tooltip_border_color = theme.transparent
	theme.tooltip_border_width = 0
	theme.tooltip_gaps = dpi(5)
	theme.tooltip_shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, dpi(6))
	end

	-- Separators
	theme.separator_color = '#f2f2f244'

	-- Layoutbox icons
	theme.layout_max = theme.icons .. 'layouts/max.svg'
	theme.layout_tile = theme.icons .. 'layouts/tile.svg'
	theme.layout_dwindle = theme.icons .. 'layouts/dwindle.svg'
	theme.layout_floating = theme.icons .. 'layouts/floating.svg'
	
	-- Taglist
	theme.taglist_bg_empty = theme.background .. '99'
	theme.taglist_bg_occupied =  '#ffffff' .. '1A'
	theme.taglist_bg_urgent = '#E91E63' .. '99'
	theme.taglist_bg_focus = theme.background
	theme.taglist_spacing = dpi(0)

	-- Tasklist
	theme.tasklist_font = 'Inter Regular 10'
	theme.tasklist_bg_normal = theme.background .. '99'
	theme.tasklist_bg_focus = theme.background
	theme.tasklist_bg_urgent = '#E91E63' .. '99'
	theme.tasklist_fg_focus = '#DDDDDD'
	theme.tasklist_fg_urgent = '#ffffff'
	theme.tasklist_fg_normal = '#AAAAAA'

	-- Notification
	theme.notification_position = 'top_left'
	theme.notification_bg = theme.transparent
	theme.notification_margin = dpi(5)
	theme.notification_border_width = dpi(0)
	theme.notification_border_color = theme.transparent
	theme.notification_spacing = dpi(5)
	theme.notification_icon_resize_strategy = 'center'
	theme.notification_icon_size = dpi(32)
	
	-- Client Snap Theme
	theme.snap_bg = theme.background
	theme.snap_shape = gears.shape.rectangle
	theme.snap_border_width = dpi(15)

	-- Hotkey popup
	theme.hotkeys_font = 'Inter Bold'
	theme.hotkeys_description_font   = 'Inter Regular Regular'
	theme.hotkeys_bg = theme.background
	theme.hotkeys_group_margin = dpi(20)
end

return {
	theme = theme,
	awesome_overrides = awesome_overrides
}
