--[[

Home program.

This program displays a simple window
with some rudimentary applications. 

It is ideally used with a monitor,
but can also be used for a terminal.

--]]

--------- Global Vars ---------
monitor = peripheral.wrap("left")
monitor.setTextScale(0.5)

widgets = {}
widgets.count = 0


---------- Program UI ---------
function display_time(line)
    local gameTime = "Game Time: " .. textutils.formatTime(os.time(), true)
    local realTime = "Real Time: " .. textutils.formatTime(os.time("local"), true)

    monitor.setCursorPos(1, line)
    monitor.write(gameTime)

    monitor.setCursorPos(mintor.getSize() - string.len(realTime) + 1, line)
    monitor.write(realTime)
end


----------- Widgets -----------
function create_button(name, x, y, onclick)
    local button = {}

    -- Create Button:
    button.type = "button"
    button.name = name
    button.startX = x
    button.startY = y
    button.endX = x + string.len(name)
    button.endY = y
    button.fnc = onclick

    -- Add Button to Widget list:
    widgets.count = widgets.count + 1
    widgets[widgets.count] = button

    return button
end


function display_widgets()
    for _, widget in ipairs(widgets) do
        monitor.setCursorPos(widget.startX, widget.startY)
        monitor.write(widget.name)
    end
end


function is_in_widget(x, y, widget)
    return widget.startX <= x and x <= widget.endX and widget.startY <= y and y <= widget.endY
end


-------- Event Handling -------
function handle_touch(x, y)
	for _, widget in ipairs(widgets) do
		if is_in_widget(x, y, widget) then
			local click_fnc = widget.fnc or function() end
			click_fnc()
		end
	end
end


function handle_events()
	while true do
		local eventData = {os.pullEvent()}
		local eventType = eventData[1]

		if eventType == "monitor_touch" then
			handle_touch(eventData[3], eventData[4])
		end
	end
end


---------- Main Loop ----------
function main_loop()
    while true do
        monitor.clear()

        display_time(1)
        display_widgets()

        sleep(1)
    end
end


--------- Program Entry -------
create_button("Test", 5, 3, function() print("Clicked on test button") end)

parallel.waitForAll(main_loop, handle_events)
