local mocks = require("__tests__.mocks.bluetooth")
local scripts = require("widget.toggles.scripts")
local utils = require("__tests__.utils")
local bluetooth_scripts = scripts.bluetooth
local watch_script = bluetooth_scripts.watch_script[3]
local luaunit = require("luaunit")
print(utils.script_path())

TestLogger = {}
-- 🔧 TODO: make error handler for io.popen
local command = _
function TestLogger:tearDown()
	command:close()
end
---@diagnostic disable-next-line: lowercase-global
function TestLogger:testOneBlockedOneUnblocked()
	local expected = "true"
	local DI = utils.DI("cat " .. mocks.one_unblocked_one_blocked, watch_script)
	command = io.popen(DI)
	local actual = assert(command):read([[*all]])
	actual = utils.serialize(actual)
	luaunit.assertEquals(actual, expected)
end
function TestLogger:test_two_unblocked()
	local expected = "true"
	local DI = utils.DI("cat " .. mocks.two_unblocked, watch_script)
	command = io.popen(DI)
	local actual = assert(command):read([[*all]])
	actual = utils.serialize(actual)
	luaunit.assertEquals(actual, expected)
end
function TestLogger:test_two_blocked()
	local expected = "false"
	local DI = utils.DI("cat " .. mocks.two_blocked, watch_script)
	command = io.popen(DI)
	local actual = assert(command):read([[*all]])
	actual = utils.serialize(actual)
	luaunit.assertEquals(actual, expected)
end
function TestLogger:test_one_blocked_one_unblocked()
	local expected = "true"
	local DI = utils.DI("cat " .. mocks.one_blocked_one_unblocked, watch_script)
	command = io.popen(DI)
	local actual = assert(command):read([[*all]])
	actual = utils.serialize(actual)
	luaunit.assertEquals(actual, expected)
end
function TestLogger:test_no_bluetooth_devices()
	local expected = "false"
	local DI = utils.DI("cat " .. mocks.no_bluetooth_devices, watch_script)
	command = io.popen(DI)
	local actual = assert(command):read([[*all]])
	actual = utils.serialize(actual)
	luaunit.assertEquals(actual, expected)
end
function TestLogger:test_no_devices()
	local expected = "false"
	local DI = utils.DI("cat " .. mocks.no_devices, watch_script)
	command = io.popen(DI)
	local actual = assert(command):read([[*all]])
	actual = utils.serialize(actual)
	luaunit.assertEquals(actual, expected)
end

os.exit(luaunit.LuaUnit.run())
