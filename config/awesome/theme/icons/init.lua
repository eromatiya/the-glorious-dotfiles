local leftpanel_icon_theme = 'macos' -- Available Themes: 'lines', 'original', 'macos'
local lit_dir = os.getenv('HOME') .. '/.config/awesome/theme/icons/themes/' .. leftpanel_icon_theme

local dir = os.getenv('HOME') .. '/.config/awesome/theme/icons'

return {
  --tags
  chrome = lit_dir .. '/google-chrome.svg',
  code = lit_dir .. '/code-braces.svg',
  social = lit_dir .. '/forum.svg',
  folder = lit_dir .. '/folder.svg',
  music = lit_dir .. '/music.svg',
  game = lit_dir .. '/google-controller.svg',
  lab = lit_dir .. '/flask.svg',
  terminal = lit_dir .. '/terminal.svg',
  art = lit_dir .. '/art.svg',
  --others
  menu = lit_dir .. '/menu.svg',
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
  plus = dir .. '/plus.svg'
}
