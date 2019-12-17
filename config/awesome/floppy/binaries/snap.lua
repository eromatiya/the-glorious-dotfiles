-- Printscreen/Screenshot bash script wrapped in lua
-- Depends : maim, xclip

local awful = require('awful')

local ss = {}

local capture_screen = function(mode)
  screen_shot_script = [[
    dir=$HOME/Pictures/Screenshots

    if [ ! -d $dir ]; then
    mkdir -p $dir
    fi

    case ']] .. mode .. [[' in
      'full')
      maim -u -m 1 $dir/$(date +%Y%m%d_%H%M%S).png
      xclip -selection clipboard -t image/png -i $dir/`ls -1 -t $dir | head -1` &
      notify-send 'Snap!' 'Screenshot saved and copied to clipboard!'
      ;;
      'area')
      maim -u -s -m 1 $dir/$(date +%Y%m%d_%H%M%S).png
      xclip -selection clipboard -t image/png -i $dir/`ls -1 -t $dir | head -1` &
      notify-send 'Snap!' 'Area screenshot saved and copied to clipboard!'
      ;;
      'select')
      maim -u -s -m 1 $dir/$(date +%Y%m%d_%H%M%S).png
      xclip -selection clipboard -t image/png -i $dir/`ls -1 -t $dir | head -1` &
      notify-send 'Snap!' 'Selected shot saved and copied to clipboard!'
      ;;
    esac
  ]]

  awful.spawn.easy_async_with_shell(screen_shot_script, function(stdout, err, out, reason) end, false)

end

fullmode = function()
  capture_screen('full')
end

areamode = function()
  capture_screen('area')
end

selectmode = function()
  capture_screen('select')
end

ss.fullmode = fullmode
ss.areamode = areamode
ss.selectmode = selectmode

return ss
