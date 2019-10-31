local panel_icon_theme = 'korla' -- Available Themes: 'drops', 'original', 'macos', 'korla'
local pit_dir = os.getenv('HOME') .. '/.config/awesome/theme/icons/panel-icon-themes/' .. panel_icon_theme

local dir = os.getenv('HOME') .. '/.config/awesome/theme/icons'

return {
  --tags
  chrome = pit_dir .. '/google-chrome.svg',
  code = pit_dir .. '/code-braces.svg',
  social = pit_dir .. '/forum.svg',
  folder = pit_dir .. '/folder.svg',
  music = pit_dir .. '/music.svg',
  game = pit_dir .. '/google-controller.svg',
  lab = pit_dir .. '/flask.svg',
  terminal = pit_dir .. '/terminal.svg',
  art = pit_dir .. '/art.svg',
  --others
  menu = pit_dir .. '/menu.svg',
  close = dir .. '/close.svg',
  logout = dir .. '/logout.svg',
  sleep = dir .. '/power-sleep.svg',
  power = dir .. '/power.svg',
  lock = dir .. '/lock.svg',
  restart = dir .. '/restart.svg',
  search = dir .. '/magnify.svg',
  volume = dir .. '/volume-high.svg',
  brightness = dir .. '/brightness-7.svg',
  chart = dir .. '/chart-areaspline.svg',
  memory = dir .. '/memory.svg',
  harddisk = dir .. '/harddisk.svg',
  thermometer = dir .. '/thermometer.svg',
  plus = dir .. '/plus.svg',
  batt_charging = dir .. '/battery-charge.svg',
  batt_discharging = dir .. '/battery-discharge.svg',
}
