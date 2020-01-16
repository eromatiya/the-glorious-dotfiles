-- Toggle picom blur fx
-- depends : picom-tryone
local awful = require('awful')

local toggfx = {}

local toggle_fx = function(togglemode)
  local toggle_fx_script = [[
  picom_dir=$HOME/.config/awesome/configuration/picom.conf

  case ]] .. togglemode .. [[ in
    'enable')
    # notify-send 'System Notification' 'Blur effects are now enabled!'
    sed -i -e 's/method = "none"/method = "dual_kawase"/g' "${picom_dir}"
    ;;
    'disable')
    # notify-send 'System Notification' 'Blur effects are now disabled!'
    sed -i -e 's/method = "dual_kawase"/method = "none"/g' "${picom_dir}"
    ;;
  esac
  ]]

  --sed -i -e 's/method = "none"/method = "dual_kawase"/g' "${picom_dir}"
  awful.spawn.easy_async_with_shell(toggle_fx_script, function(stdout, stderr)
    -- require('naughty').notify({message = tostring(stdout .. ' + ' .. stderr)})
  end, false)

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
