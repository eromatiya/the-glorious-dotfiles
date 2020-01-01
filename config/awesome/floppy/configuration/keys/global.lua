local awful = require('awful')
require('awful.autofocus')
local beautiful = require('beautiful')
local hotkeys_popup = require('awful.hotkeys_popup').widget

local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey
local apps = require('configuration.apps')
-- Key bindings
local globalKeys =
  awful.util.table.join(
  -- Hotkeys
  awful.key({modkey}, 'F1', hotkeys_popup.show_help, {description = 'show help', group = 'awesome'}),
  -- Custom Keys
  awful.key(
    {modkey}, 'Return',
    function()
      awful.spawn(apps.default.terminal)
    end,
    { description = "Open Terminal", group = "launcher"}),
  awful.key(
    {modkey}, 'e',
    function()
      _G.screen.primary.left_panel:HideDashboard()
      _G.screen.primary.right_panel:HideDashboard()
      awful.util.spawn(apps.default.rofiappmenu)
    end,
  { description = "Open Application Drawer", group = "launcher"}),
  awful.key(
    {modkey}, 'x',
    function()
      if require('widget.right-dashboard') then
        _G.screen.primary.right_panel:toggle()
      end
    end,
  { description = "Open Notification Center", group = "launcher"}),
  awful.key(
    {modkey, "Shift"}, 'f',
    function()
      awful.spawn("firefox")
    end,
    { description = "Open Browser", group = "launcher"}),

  awful.key(
    {modkey, "Shift"}, 'e',
    function()
      awful.spawn("nemo")
    end,
    { description = "Open file manager", group = "launcher"}),

  awful.key(
    {"Control", "Shift"}, 'Escape',
    function()
      awful.spawn("gnome-system-monitor")
    end,
    { description = "Open system monitor", group = "launcher"}),

  -- Screen Shots
  awful.key(
  { }, "Print",
  function ()
    apps.bins.fullShot()
  end,
  { description = "Fullscreen screenshot", group = "Miscellaneous"}),
  awful.key(
  {modkey, "Shift"}, 's',
  function ()
    apps.bins.areaShot()
  end,
  { description = "Area screenshot", group = "Miscellaneous"}),
  awful.key(
  {modkey, altkey}, 's',
  function ()
    apps.bins.areaShot()
  end,
  { description = "Selected screenshot", group = "Miscellaneous"}),

  -- Music Widget
  awful.key(
    {modkey}, 'm',
    function()
      if require("widget.music") then
        _G.toggle_player()
      end
    end,
  { description = "Open Music Widget", group = "launcher"}),

  -- Toggle System Tray
  awful.key({ 'Control' }, 'Escape', function ()
    awesome.emit_signal("toggle_tray")
  end, {description = "Toggle systray visibility", group = "Miscellaneous"}),

  -- Tag browsing
  awful.key({modkey}, 'w', awful.tag.viewprev, {description = 'view previous', group = 'tag'}),
  awful.key({modkey}, 's', awful.tag.viewnext, {description = 'view next', group = 'tag'}),
  awful.key({modkey}, 'Escape', awful.tag.history.restore, {description = 'go back', group = 'tag'}),

  -- Non-empty tag browsing
  awful.key({ modkey, "Control" }, "w",
    function ()
      -- tag_view_nonempty(-1)
      local s = sc or awful.screen.focused()
      for i = 1, #s.tags do
        awful.tag.viewidx(-1, s)
        if #s.clients > 0 then
          return
        end
      end
  end, {description = "view previous non-empty tag", group = "tag"}),
  awful.key({ modkey, "Control" }, "s",
    function ()
      -- tag_view_nonempty(1)
      local s = sc or awful.screen.focused()
      for i = 1, #s.tags do
        awful.tag.viewidx(1, s)
        if #s.clients > 0 then
          return
        end
      end
  end, {description = "view next non-empty tag", group = "tag"}),
  
  -- Default client focus
  awful.key(
    {modkey},
    'd',
    function()
      awful.client.focus.byidx(1)
    end,
    {description = 'focus next by index', group = 'client'}
  ),
  awful.key(
    {modkey},
    'a',
    function()
      awful.client.focus.byidx(-1)
    end,
    {description = 'focus previous by index', group = 'client'}
  ),
  awful.key(
    { modkey, "Shift"   },
     "d",
      function ()
        awful.client.swap.byidx(1)
      end,
      {description = "swap with next client by index", group = "client"}
    ),
    awful.key(
      { modkey, "Shift"   },
       "a",
        function ()
          awful.client.swap.byidx(-1)
        end,
        {description = "swap with next client by index", group = "client"}
      ),
  awful.key(
    {modkey},
    'r',
    function()
      _G.screen.primary.left_panel:toggle(true)
    end,
    {description = 'Open Sidebar', group = 'launcher'}
  ),
  awful.key({modkey}, 'u', awful.client.urgent.jumpto, {description = 'jump to urgent client', group = 'client'}),
  awful.key(
    {modkey},
    'Tab',
    function()
      awful.client.focus.history.previous()
      if _G.client.focus then
        _G.client.focus:raise()
      end
    end,
    {description = 'go back', group = 'client'}
  ),
  -- Programms
  awful.key(
    {modkey},
    'l',
    function()
      awful.spawn(apps.default.lock)
    end
  ),
  --[[
  awful.key(
    {},
    'Print',
    function()
      awful.util.spawn_with_shell('maim -s | xclip -selection clipboard -t image/png')
    end
  ),]]
  -- Standard program
  awful.key({modkey, 'Control'}, 'r', _G.awesome.restart, {description = 'reload awesome', group = 'awesome'}),
  awful.key({modkey, 'Control'}, 'q', _G.awesome.quit, {description = 'quit awesome', group = 'awesome'}),
  awful.key(
    {altkey, 'Shift'},
    'l',
    function()
      awful.tag.incmwfact(0.05)
    end,
    {description = 'increase master width factor', group = 'layout'}
  ),
  awful.key(
    {altkey, 'Shift'},
    'h',
    function()
      awful.tag.incmwfact(-0.05)
    end,
    {description = 'decrease master width factor', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'h',
    function()
      awful.tag.incnmaster(1, nil, true)
    end,
    {description = 'increase the number of master clients', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'l',
    function()
      awful.tag.incnmaster(-1, nil, true)
    end,
    {description = 'decrease the number of master clients', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Control'},
    'h',
    function()
      awful.tag.incncol(1, nil, true)
    end,
    {description = 'increase the number of columns', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Control'},
    'l',
    function()
      awful.tag.incncol(-1, nil, true)
    end,
    {description = 'decrease the number of columns', group = 'layout'}
  ),
  awful.key(
    {modkey},
    'space',
    function()
      awful.layout.inc(1)
    end,
    {description = 'select next', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'space',
    function()
      awful.layout.inc(-1)
    end,
    {description = 'select previous', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Control'},
    'n',
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        _G.client.focus = c
        c:raise()
      end
    end,
    {description = 'restore minimized', group = 'client'}
  ),
  -- Dropdown application
  awful.key(
    {modkey},
    '`',
    function()
      _G.toggle_quake()
    end,
    {description = 'dropdown application', group = 'launcher'}
  ),
  -- Widgets popups
  awful.key(
    {altkey},
    'h',
    function()
      if beautiful.fs then
        beautiful.fs.show(7)
      end
    end,
    {description = 'show filesystem', group = 'widgets'}
  ),
  awful.key(
    {altkey},
    'w',
    function()
      if beautiful.weather then
        beautiful.weather.show(7)
      end
    end,
    {description = 'show weather', group = 'widgets'}
  ),
  -- Brightness
  awful.key(
    {},
    'XF86MonBrightnessUp',
    function()
      awful.spawn('xbacklight -inc 10', false)
      if toggleBriOSD ~= nil then
        _G.toggleBriOSD(true)
      end
      if UpdateBrOSD ~= nil then
        _G.UpdateBrOSD()
      end
    end,
    {description = '+10%', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86MonBrightnessDown',
    function()
      awful.spawn('xbacklight -dec 10', false)
      if toggleBriOSD ~= nil then
        _G.toggleBriOSD(true)
      end
      if UpdateBrOSD ~= nil then
        _G.UpdateBrOSD()
      end
    end,
    {description = '-10%', group = 'hotkeys'}
  ),
  -- ALSA volume control
  awful.key(
    {},
    'XF86AudioRaiseVolume',
    function()
      awful.spawn('amixer -D pulse sset Master 5%+', false)
      if toggleVolOSD ~= nil then
        _G.toggleVolOSD(true)
      end
      if UpdateVolOSD ~= nil then
        _G.UpdateVolOSD()
      end
    end,
    {description = 'volume up', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioLowerVolume',
    function()
      awful.spawn('amixer -D pulse sset Master 5%-', false)
      if toggleVolOSD ~= nil then
        _G.toggleVolOSD(true)
      end
      if UpdateVolOSD ~= nil then
        _G.UpdateVolOSD()
      end
    end,
    {description = 'volume down', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioMute',
    function()
      awful.spawn('amixer -D pulse set Master 1+ toggle', false)
    end,
    {description = 'toggle mute', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioNext',
    function()
      awful.spawn('mpc next', false)
    end,
    {description = 'next music', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioPrev',
    function()
      awful.spawn('mpc prev', false)
    end,
    {description = 'previous music', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioPlay',
    function()
      awful.spawn('mpc toggle', false)
    end,
    {description = 'play/pause music', group = 'hotkeys'}

  ),
  awful.key(
    {},
    'XF86AudioMicMute',
    function()
      awful.spawn('amixer set Capture toggle', false)
    end,
    {description = 'Mute Microphone', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86PowerDown',
    function()
      --
    end,
    {description = 'toggle mute', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86PowerOff',
    function()
      _G.exit_screen_show()
    end,
    {description = 'toggle exit screen', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86Display',
    function()
      awful.spawn('arandr', false)
    end,
    {description = 'arandr', group = 'hotkeys'}
  )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
  local descr_view, descr_toggle, descr_move, descr_toggle_focus
  if i == 1 or i == 9 then
    descr_view = {description = 'view tag #', group = 'tag'}
    descr_toggle = {description = 'toggle tag #', group = 'tag'}
    descr_move = {description = 'move focused client to tag #', group = 'tag'}
    descr_toggle_focus = {description = 'toggle focused client on tag #', group = 'tag'}
  end
  globalKeys =
    awful.util.table.join(
    globalKeys,
    -- View tag only.
    awful.key(
      {modkey},
      '#' .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      descr_view
    ),
    -- Toggle tag display.
    awful.key(
      {modkey, 'Control'},
      '#' .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      descr_toggle
    ),
    -- Move client to tag.
    awful.key(
      {modkey, 'Shift'},
      '#' .. i + 9,
      function()
        if _G.client.focus then
          local tag = _G.client.focus.screen.tags[i]
          if tag then
            _G.client.focus:move_to_tag(tag)
          end
        end
      end,
      descr_move
    ),
    -- Toggle tag on focused client.
    awful.key(
      {modkey, 'Control', 'Shift'},
      '#' .. i + 9,
      function()
        if _G.client.focus then
          local tag = _G.client.focus.screen.tags[i]
          if tag then
            _G.client.focus:toggle_tag(tag)
          end
        end
      end,
      descr_toggle_focus
    )
  )
end

return globalKeys
