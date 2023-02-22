local utils = require("__tests__.utils")
local curr_dir = utils.script_path()
local mocks = {
	one_unblocked_one_blocked = curr_dir .. "one-unblocked-one-blocked.json",
	one_blocked_one_unblocked = curr_dir .. "one-blocked-one-unblocked.json",
	two_blocked = curr_dir .. "two-blocked.json",
	two_unblocked = curr_dir .. "two-unblocked.json",
	no_bluetooth_devices = curr_dir .. "no-bluetooth-devices.json",
	no_devices = curr_dir .. "no-devices.json",
}
return mocks
