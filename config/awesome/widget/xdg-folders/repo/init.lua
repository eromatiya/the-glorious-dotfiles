local awful = require("awful")
local gears = require("gears")
local icons = require("widget.xdg-folders.icons")
local button_widget = require("widget.xdg-folders.entities.button")
---@alias folder_repo {name: string, image: string, click_cb: function, margins: string}
---@alias folder_names "home" | "documents" | "downloads" | "pictures" | "videos" | "trash"
---@type table< folder_names, folder_repo>
local repo = {
	home = {
		image = icons.home,
		name = "Home",
		click_cb = function()
			awful.spawn.with_shell("xdg-open $(xdg-user-dir)")
		end,
		margins = _,
	},
	documents = {
		image = icons.documents,
		name = "Documents",
		click_cb = function()
			awful.spawn.with_shell("xdg-open $(xdg-user-dir DOCUMENTS)")
		end,
		margins = _,
	},
	downloads = {
		image = icons.downloads,
		name = "Downloads",
		click_cb = function()
			awful.spawn.with_shell("xdg-open $(xdg-user-dir DOWNLOAD)")
		end,
		margins = _,
	},
	trash = {
		image = icons.trash_empty,
		name = "Trash",
		click_cb = function()
			awful.spawn({ "gio", "open", "trash:///" }, false)
		end,
		margins = _,
	},
}
---@type table<folder_names, any>
-- local button_widgets = {}
-- for i, v in pairs(repo) do
-- 	button_widgets[i] = button_widget:new(v.name, v.image, v.margins, v.click_cb)
-- end
return repo
