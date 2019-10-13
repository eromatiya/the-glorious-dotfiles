local filesystem = require('gears.filesystem')
local mat_colors = require('theme.mat-colors')
local theme_dir = filesystem.get_configuration_dir() .. '/theme'
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local theme = {}
theme.icons = theme_dir .. '/icons/'
theme.font = 'Roboto medium 10'

-- Colors Pallets

-- Custom
theme.custom = '#ffffff'

-- Primary
theme.primary = mat_colors.deep_orange

-- Accent
theme.accent = mat_colors.pink

-- Background
theme.background = mat_colors.grey

local awesome_overrides =
  function(theme)
  theme.dir = os.getenv('HOME') .. '/.config/awesome/theme'

  theme.icons = theme.dir .. '/icons/'

  -- Default Wallpaper if Dynamic wallpaper module is not loaded
  theme.wallpaper = theme.dir .. '/wallpapers/day-wallpaper.jpg'

  theme.font = 'Roboto medium 10'
  theme.title_font = 'Roboto medium 14'

  theme.fg_normal = '#ffffffde'

  theme.fg_focus = '#e4e4e4'
  theme.fg_urgent = '#CC9393'
  theme.bat_fg_critical = '#232323'

  theme.bg_normal = theme.background.hue_800
  theme.bg_focus = '#5a5a5a'
  theme.bg_urgent = '#3F3F3F'
  theme.bg_systray = theme.background.hue_800

  -- Borders

  theme.border_width = dpi(2)
  theme.border_normal = theme.background.hue_800
  theme.border_focus = theme.primary.hue_300
  theme.border_marked = '#CC9393'

  -- Menu

  theme.menu_height = 34
  theme.menu_width = 180

  -- Tooltips
  theme.tooltip_bg = '#000000' .. '66'
  --theme.tooltip_border_color = '#232323'
  theme.tooltip_border_width = 0
  theme.tooltip_shape = function(cr, w, h)
    gears.shape.rounded_rect(cr, w, h, dpi(6))
  end

  -- Layout

  theme.layout_max = theme.icons .. 'layouts/arrow-expand-all.png'
  theme.layout_tile = theme.icons .. 'layouts/view-quilt.png'
  theme.layout_dwindle = theme.icons .. 'layouts/dwindle.png'

  -- Taglist

  theme.taglist_bg_empty = theme.background.hue_800 .. '99'
  theme.taglist_bg_occupied =  '#ffffff' .. '1A'  --theme.background.hue_800
    -- 'linear:0,0:' ..
    -- dpi(48) ..
    --   ',0:0,' ..
    --     '#ffffff' ..
    --       ':0.08,' .. '#ffffff' .. ':0.08,' .. theme.background.hue_800 .. '99' .. theme.background.hue_800
  theme.taglist_bg_urgent = theme.accent.hue_500 .. '99'
    -- 'linear:0,0:' ..
    -- dpi(48) ..
    --   ',0:0,' ..
    --     theme.accent.hue_500 ..
    --       ':0.08,' .. theme.accent.hue_500 .. ':0.08,' .. theme.background.hue_800 .. ':1,' .. theme.background.hue_800
  theme.taglist_bg_focus = theme.background.hue_800
    -- 'linear:0,0:' ..
    -- dpi(48) ..
    --   ',0:0,' ..
    --     theme.primary.hue_500 ..
    --       ':0.08,' .. theme.primary.hue_500 .. ':0.08,' .. theme.background.hue_800 .. ':1,' --[[':1,']] .. theme.background.hue_800

  -- Tasklist

  theme.tasklist_font = 'Roboto Regular 10'
  theme.tasklist_bg_normal = theme.background.hue_800 .. '99'
  theme.tasklist_bg_focus =
    'linear:0,0:0,' ..
    dpi(48) ..
      ':0,' ..
        theme.background.hue_800 ..
          ':0.95,' .. theme.background.hue_800 .. ':0.95,' .. theme.fg_normal .. ':1,' .. theme.fg_normal
  theme.tasklist_bg_urgent = theme.primary.hue_800
  theme.tasklist_fg_focus = '#DDDDDD'
  theme.tasklist_fg_urgent = theme.fg_normal
  theme.tasklist_fg_normal = '#AAAAAA'

  theme.icon_theme = 'Papirus-Dark'

  --Client
  theme.border_width = dpi(0)
  theme.border_focus = theme.primary.hue_500
  theme.border_normal = theme.background.hue_800
end
return {
  theme = theme,
  awesome_overrides = awesome_overrides
}
