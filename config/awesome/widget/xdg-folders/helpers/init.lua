local awful = require("awful")
local icons = require("widget.xdg-folders.icons")
local check_trash_list = function(trash_button)
	awful.spawn.easy_async_with_shell("gio list trash:/// | wc -l", function(stdout)
		if tonumber(stdout) > 0 then
			trash_button:set_image(icons.trash_full)
			awful.spawn.easy_async_with_shell("gio list trash:///", function(stdout)
				trash_button:set_markup("<b>Trash contains:</b>\n" .. stdout:gsub("\n$", ""))
			end)
		else
			trash_button:set_image(icons.trash_empty)
			trash_button:set_markup("Trash empty")
		end
	end)
end
---@type {check_trash_list: function}
local helpers = {
	check_trash_list = check_trash_list,
}
return helpers
