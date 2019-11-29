-- Toggle compton blur fx
-- depends : compton-tryone
local awful = require('awful')

local toggfx = {}

local toggle_fx = function(togglemode)
  local toggle_fx_script = [[
  comptonDir=$HOME/.config/awesome/configuration/compton.conf
  compton_id=0

  function kill_compton() {
    compton_id=$(pidof compton)
    if [ ! -z compton_id ]; then
      kill -9 $(pidof compton)
    fi
  }

  case ]] .. togglemode .. [[ in
    'enable')
    kill_compton
    sed -i -e 's/blur-background-frame = false/blur-background-frame = true/g' "${comptonDir}"
    compton --config ${comptonDir} &> /dev/null
    notify-send 'System Notification' 'Blur effects are now enabled!'
    ;;
    'disable')
    kill_compton
    sed -i -e 's/blur-background-frame = true/blur-background-frame = false/g' "${comptonDir}"
    compton --config ${comptonDir} &> /dev/null
    notify-send 'System Notification' 'Blur effects are now disabled!'
    ;;
  esac
  ]]

  awful.spawn.easy_async_with_shell(toggle_fx_script, function(stdout, stderr, out, exit) end, false)

end


local enablefx = function()
  toggle_fx('enable')
end

local disablefx = function()
  toggle_fx('disable')
end

toggfx.enable = enablefx
toggfx.disable = disablefx

return toggfx
