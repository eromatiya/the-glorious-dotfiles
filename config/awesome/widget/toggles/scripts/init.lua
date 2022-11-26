---@alias shell_script  string | string[]
---@alias toggle_scripts {  toggle_on_script: shell_script , toggle_off_script: shell_script, watch_script: shell_script}
---@type table<toggle_widgets, toggle_scripts>
local curr_dir = require("__tests__.utils").script_path()
local sh_dir = curr_dir .. "sh/"
local sh_blue_light_dir = sh_dir .. "blue_light/"

local scripts = {
	bluetooth = {
		watch_script = {
			"bash",
			"-c",
			[[rfkill -J |  jq -c  '.rfkilldevices | map(select(.type | test( "bluetooth"; "i"))) | map(select(.soft == "unblocked")) | if length != 0 then true else false end']],
		},
		toggle_off_script = "rfkill block bluetooth",
		toggle_on_script = "rfkill unblock bluetooth",
	},
	airplane_mode = {
		watch_script = {
			"bash",
			"-c",
			[[rfkill -J |  jq -c  '.rfkilldevices | map(select(.type | test( "wlan"; "i"))) | map(select(.soft == "unblocked")) | if length != 0 then false else true end']],
		},
		toggle_off_script = "rfkill unblock wlan",
		toggle_on_script = "rfkill block wlan",
	},
	blue_light = {
		-- 🔧 TODO: implement
		watch_script = _,
		toggle_off_script = "redshift -x && pkill redshift && killall redshift",
		toggle_on_script = "redshift -l 0:0 -t 4500:4500 -r &>/dev/null",
	},
	blur_effects = {
		-- 🔧 TODO: implement
		watch_script = _,
		toggle_off_script = "sh " .. sh_blue_light_dir .. "/toggle_off_script.sh",
		toggle_on_script = "sh " .. sh_blue_light_dir .. "/toggle_on_script.sh",
	},
}
return scripts
