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

    monitor.setCursorPos(monitor.getSize() - string.len(realTime) + 1, line)
    monitor.write(realTime)
end


----------- Widgets -----------
function create_button(name, x, y, onclick)
    local button = {}
    local name_len = string.len(name)

    -- Create Button:
    button.type = "button"
    button.name = name
    button.startX = x
    button.startY = y
    button.endX = x + name_len
    button.endY = y
    button.fg = string.rep("0", name_len)
    button.bg = string.rep("f", name_len)
    button.activeFrames = 0
    button.update = button_update
    button.fnc = onclick or function() end

    -- Add Button to Widget list:
    widgets.count = widgets.count + 1
    widgets[widgets.count] = button

    return button
end

function button_update(button)
    if button.activeFrames > 0 then
        button.activeFrames = button.activeFrames - 1

        if button.activeFrames == 0 then
            button.bg = string.rep("f", string.len(button.name))
        end
    end
end

function click_button(button)
    button.bg = string.rep("b", string.len(button.name))
    button.activeFrames = 5
    button.fnc()
end

function update_widgets()
    for _, widget in ipairs(widgets) do
        widget.update(widget)
    end
end

function display_widgets()
    for _, widget in ipairs(widgets) do
        monitor.setCursorPos(widget.startX, widget.startY)
        monitor.blit(widget.name, widget.fg, widget.bg)
    end
end


function is_in_widget(x, y, widget)
    return widget.startX <= x and x <= widget.endX and widget.startY <= y and y <= widget.endY
end


-------- Event Handling -------
function handle_touch(x, y)
	for _, widget in ipairs(widgets) do
		if is_in_widget(x, y, widget) then
			click_button(widget)
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
        monitor.setCursorPos(1, 3)
        monitor.write("Menu:")
        monitor.setCursorPos(1, 4)
        monitor.write("> ")

        update_widgets()
        display_widgets()

        sleep(0.025)
    end
end


--------- Program Entry -------
create_button("[Do something]", 3, 4, function() print("Clicked on test button") end)

parallel.waitForAll(main_loop, handle_events)
