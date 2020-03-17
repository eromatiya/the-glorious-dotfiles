-- This module gets the right x, y for music-box
-- Bug is expected.

local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi

local margin_return = function(s, music_box_width, side_margin)

    s.margin_x = s.geometry.x
    s.margin_y = s.geometry.y

    local function do_find_hierarchy_for_widget(result, hierarchy, widget)
        -- We are given an instance of wibox.hierarchy. Is it for the right widget?
        if widget == hierarchy:get_widget() then
          table.insert(result, hierarchy)
        end

      -- Scan all children in the tree
        for _, h in ipairs(hierarchy:get_children()) do
            do_find_hierarchy_for_widget(result, h, widget)
        end
    end

    function find_hierarchy_for_widget_in_wibox(wibox, widget)
        -- Actually, we need the instance of wibox.drawable for the wibox
        local drawable = wibox._drawable
        -- Well, no. Actually we want the instance of wibox.hierarchy describing the
        -- root of the widget tree.
        local hierarchy = drawable._widget_hierarchy

        local result = {}
        if hierarchy then
          do_find_hierarchy_for_widget(result, hierarchy, widget)
        end
      
        return result

    end


    s.margin_returner = gears.timer.start_new(3, function()

        local focused_top_panel = s.top_panel
        local focused_left_panel = s.left_panel
        local focused_music_button = s.music
        
        x_margin = 0
        y_margin = 0

        widget_x = 0
        widget_y = 0

        point_x = 0

        for _, hierarchy in ipairs(find_hierarchy_for_widget_in_wibox(focused_top_panel, focused_music_button)) do

            local x, y = hierarchy:get_matrix_to_device():transform_point(0, 0)

            widget_x = x
            widget_y = y
            widget_size = hierarchy:get_size()
        end


        if s.index == 1 then

            point_x = math.floor(
                (s.geometry.x + s.geometry.width) -
                    (widget_x + widget_size + side_margin)
            )

            x_margin = math.floor(
                point_x - (music_box_width / 2) - (widget_size / 2)
            )

            if x_margin < 0 then
                x_margin = 5
            elseif x_margin >= s.geometry.width - music_box_width then
                x_margin = s.geometry.width - focused_left_panel.width - 
                    music_box_width - 5
            end

        else
            point_x = math.floor(
                s.geometry.width - (widget_x + widget_size - side_margin)
            )

            x_margin = math.floor(
                point_x - music_box_width / 2
            )

            if x_margin < 0 then
                x_margin = 5
            elseif x_margin >= s.geometry.width - music_box_width then
                x_margin = s.geometry.width - music_box_width - 5
            end

        end



        y_margin = widget_size + dpi(5)

        s.margin_x = x_margin

        s.margin_y = y_margin

    end)


end


return margin_return