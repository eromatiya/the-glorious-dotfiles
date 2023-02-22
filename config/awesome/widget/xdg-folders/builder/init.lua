local repo = require("widget.xdg-folders.repo")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local button_class = require("widget.xdg-folders.entities.button")
local helpers = require("widget.xdg-folders.helpers")
local separator = require("widget.shared.components.separator")
---@class xdg_folders_builder
---@field elements table
---@field separators table
---@field with_home fun(builder):xdg_folders_builder
---@field with_downloads fun(builder):xdg_folders_builder
---@field with_documents fun(builder):xdg_folders_builder
---@field with_separator fun(builder):xdg_folders_builder
---@field with_trash fun(builder):xdg_folders_builder
---@field horizontal fun(builder):xdg_folders_builder
---@field vertical fun(builder):xdg_folders_builder
---@field build fun(builder):any
---@type xdg_folders_builder
local builder = { elements = {}, separators = {} }
function builder:add_button(params)
	table.insert(self.elements, button_class:new(params.name, params.image, params.margins, params.click_cb))
	return self
end
function builder:with_home()
	return self:add_button(repo.home)
end
function builder:with_documents()
	return self:add_button(repo.documents)
end
function builder:with_downloads()
	return self:add_button(repo.downloads)
end
function builder:with_separator()
	local sep = separator:new()
	table.insert(self.separators, sep)
	table.insert(self.elements, sep)
	return self
end
function builder:with_trash()
	self:add_button(repo.trash)
	local trash_button = self.elements[#self.elements]
	helpers.check_trash_list(trash_button)
	return self
end
function builder:change_separators_orientation(orientation)
	for _, sep in ipairs(self.separators) do
		print(sep)
		sep:set_orientation(orientation)
	end
end
function builder:horizontal()
	self:change_separators_orientation("vertical")
	self.align_widget = wibox.layout.fixed.horizontal()
	return self
end
function builder:vertical()
	self:change_separators_orientation("horizontal")
	self.align_widget = wibox.layout.fixed.vertical()
	return self
end
function builder:build()
	for i, v in ipairs(self.elements) do
		self.align_widget:add(v.widget)
	end
	return self.align_widget
end
return builder
