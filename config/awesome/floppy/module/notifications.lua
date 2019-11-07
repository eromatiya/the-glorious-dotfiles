local naughty = require('naughty')
local beautiful = require('beautiful')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local icons = require('theme.icons')

-- Defaults
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = dpi(32)
naughty.config.defaults.screen = 1
naughty.config.defaults.timeout = 5
naughty.config.defaults.shape = function(cr, w, h) gears.shape.rounded_rect(cr, w, h, dpi(6)) end
naughty.config.defaults.title = 'System Notification'

-- -- Apply theme variables
naughty.config.padding = 8
naughty.config.spacing = 8
naughty.config.defaults.margin = dpi(16)
naughty.config.defaults.border_width = 0

-- Timeouts
naughty.config.presets.low.timeout = 3
naughty.config.presets.critical.timeout = 0

naughty.config.presets.normal = {
  font         = 'SFNS Display 10',
  fg           = beautiful.fg_normal,
  bg           = beautiful.background.hue_800,
  border_width = 0,
  margin       = dpi(16),
  position     = 'top_right'
}

naughty.config.presets.low = {
  font         = 'SFNS Display 10',
  fg           = beautiful.fg_normal,
  bg           = beautiful.background.hue_800,
  border_width = 0,
  margin       = dpi(16),
  position     = 'top_right'
}

naughty.config.presets.critical = {
  font         = 'SFNS Display Bold 10',
  fg           = '#ffffff',
  bg           = '#ff0000',
  border_width = 0,
  margin       = dpi(16),
  position     = 'top_right',
  timeout      = 0
}


naughty.config.presets.ok = naughty.config.presets.normal
naughty.config.presets.info = naughty.config.presets.normal
naughty.config.presets.warn = naughty.config.presets.critical


-- Error handling
if _G.awesome.startup_errors then
  naughty.notify(
    {
      preset = naughty.config.presets.critical,
      title = 'Oops, there were errors during startup!',
      text = _G.awesome.startup_errors
    }
  )
end

do
  local in_error = false
  _G.awesome.connect_signal(
    'debug::error',
    function(err)
      if in_error then
        return
      end
      in_error = true

      naughty.notify(
        {
          preset = naughty.config.presets.critical,
          title = 'Oops, an error happened!',
          text = tostring(err)
        }
      )
      in_error = false
    end
  )
end

function log_this(title, txt)
  naughty.notify(
    {
      title = 'log: ' .. title,
      text = txt
    }
  )
end
