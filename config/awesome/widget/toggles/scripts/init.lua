---@alias shell_script  string | string[]
---@alias toggle_scripts {  toggle_on_script: shell_script , toggle_off_script: shell_script, watch_script: shell_script}
---@type table<toggle_widgets, toggle_scripts>
local scripts = {
	bluetooth = {
		watch_script = {
			"bash",
			"-c",
			[[rfkill -J |  jq -c  '.rfkilldevices | map(select(.type | test( "bluetooth"; "i"))) | map(select(.soft == "unblocked")) | if length != 0 then true else false end']],
		},
		toggle_off_callback = "rfkill block bluetooth",
		toggle_on_callback = "rfkill unblock bluetooth",
	},
}
return scripts
