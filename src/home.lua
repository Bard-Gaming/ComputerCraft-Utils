--[[

Home program.

This program displays a simple window
with some rudimentary applications. 

It is ideally used with a monitor,
but can also be used for a terminal.

--]]

local widgets = require "widgets"

--------- Global Vars ---------
monitor = peripheral.wrap("left")
monitor.setTextScale(0.5)

---------- Program UI ---------
function display_time(line)
    local gameTime = "Game Time: " .. textutils.formatTime(os.time(), true)
    local realTime = "Real Time: " .. textutils.formatTime(os.time("local"), true)

    monitor.setCursorPos(1, line)
    monitor.write(gameTime)

    monitor.setCursorPos(monitor.getSize() - string.len(realTime) + 1, line)
    monitor.write(realTime)
end


-------- Event Handling -------
function handle_touch(x, y)
    widgets.forEach(function(widget)
        if widgets.inWidget(x, y, widget) then
            widgets.clickButton(widget)
        end
    end)
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

        widgets.updateAll()
        widgets.displayAll(monitor)

        sleep(0.025)
    end
end


--------- Program Entry -------
widgets.createButton("[Do something]", 3, 4, function() print("Clicked on test button") end)

parallel.waitForAll(main_loop, handle_events)
