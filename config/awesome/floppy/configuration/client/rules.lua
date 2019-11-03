local awful = require('awful')
local gears = require('gears')
local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.buttons')
local roundCorners = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 12)
end

-- Rules
awful.rules.rules = {
  -- All clients will match this rule.
  {
    rule = {},
    except_any = {
      instance = {
        'nm-connection-editor',
        'file_progress'
      }
    },
    properties = {
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen,
      floating = false,
      maximized = false,
      above = false,
      below = false,
      ontop = false,
      sticky = false,
      maximized_horizontal = false,
      maximized_vertical = false

    }
  },
  { rule_any = { name = {'QuakeTerminal'} },
    properties = { skip_decoration = true }
  },

  -- Terminals
  {
    rule_any = {
       class = {
			"URxvt",
			"XTerm",
			"UXTerm",
      "kitty"
       },
    },
        properties = {
          screen = 1, tag = '1',
          switchtotag = true,
          titlebars_enabled = true
      }
  },

  -- Browsers
  {
    rule_any = {
		class = {
			"firefox"
       },
    },
        properties = { screen = 1, tag = '2' }
  },

  -- Editors
  {
	rule_any = {
		class = {
			"Geany",
      "Atom",
      "Subl3"
		},
	},
		properties = { screen = 1, tag = '3' }
  },

  -- File Managers
  {
    rule_any = {
       class = {
         "Nemo",
         "File-roller"
       },
    },
        properties = { tag = '4', switchtotag = true }
  },
    -- Multimedia
  {
    rule_any = {
      class = {
        "vlc"
       },
    },
        properties = { tag = '5' }
  },
	-- Games

  {
	rule_any = {

		class = {
			"Wine",
      "dolphin-emu",
      "Steam"
		},
  --s  instance = { 'SuperTuxKart' }
	},
		properties = {
      screen = 1,
      tag = '6',
      switchtotag = true,
      floating = true,
      titlebars_enabled = true
    }
  },

  -- Multimedia Editing
  {
	rule_any = {
		class = {
			"Gimp-2.10",
			"Inkscape"
		},
	},
		properties = { screen = 1, tag = '7'}
  },

  -- Virtualbox
  {
  rule_any = {
    class = {
      "VirtualBox Manage",
    },
  },
    properties = { screen = 1, tag = '8'}
  },


  -- Workspace Editing
  {
	rule_any = {
		class = {
			"Oomox",
		},
	},
		properties = { screen = 1, tag = '9'}
  },

  -- Custom
  {
  rule_any = {
    class = {
      "feh",
      "Mugshot",
      "Pulseeffects",
    },
  },
    properties = {
    skip_decoration = true,
    titlebars_enabled = true,
    floating = true,
    placement = awful.placement.centered,
    ontop = true
    }
  },


  {
  rule_any = {
    class = {
      "xlunch-fullscreen"
    },
  },
    properties = {
    skip_decoration = true,
    fullscreen = true,
    ontop = true
    }
  },


  -- Dialogs
  {
    rule_any = {type = {'dialog'}, class = {'Wicd-client.py', 'calendar.google.com'}},
    properties = {
      placement = awful.placement.centered,
      ontop = true,
      floating = true,
      drawBackdrop = true, -- TRUE if you want to add blur backdrop
      skip_decoration = true,
      shape = roundCorners,
    }
  },


  -- Intstances
  -- Network Manager Editor
  {
    rule = {
      instance = 'nm-connection-editor'
    },
    properties = {
      skip_decoration = true,
      ontop= true,
      floating = true,
      drawBackdrop = false,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons
    }
  },
-- For nemo progress bar when copying or moving
  {
    rule = {
      instance = 'file_progress'
    },
    properties = {
      skip_decoration = true,
      ontop= true,
      floating = true,
      drawBackdrop = false,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      placement = awful.placement.centered
    }
  },

  {
    -- For Firefox Popup when you open incognito mode
    rule = {
      instance = 'Popup'
    },
    properties = {
      skip_decoration = true,
      ontop= true,
      floating = true,
      drawBackdrop = false,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons
    }
  }
}




-- Normally we'd do this with a rule but Spotify and SuperTuxKart doesnt set
-- its class or name until is starts up, so we need to catch that signal
client.connect_signal("property::class",function(c)

  if c.class == 'Spotify' or c.class == 'SuperTuxKart' then
    -- Check if already opened
    local app = function(c)
      if c.class == 'SuperTuxKart' then
        return awful.rules.match(c, { class = 'SuperTuxKart' } )
      elseif c.class == 'Spotify' then
        return awful.rules.match(c, { class = 'Spotify' } )
      end
    end

      -- Move it to the desired tag in THIS SCREEN
    local tagName = ''
    if c.class == 'Spotify' then
      tagName = '5'
    elseif c.class == 'SuperTuxKart' then
      tagName = '6'
    end
    local t = awful.tag.find_by_name(awful.screen.focused(), tagName)
    c:move_to_tag(t)
    t:view_only()

    if c.class == 'SuperTuxKart' then
      -- Two fullscreen mode to remove bug
      -- Yeah it's a hackish way, but it works so whatever
      -- Make sure to enable fullscreen in SuperTuxKart Settings
      -- Not tested on not Fullscreen mode in Settings
      -- Make sure! Or maybe it can delete your root directory
      c.fullscreen = not c.fullscreen
      c.fullscreen = not c.fullscreen
      c:raise()
    end
  end
end)
