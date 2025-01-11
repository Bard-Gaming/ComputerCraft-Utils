--[[

Home program.

This program displays a simple window
with some rudimentary applications. 

It is ideally used with a monitor,
but can also be used for a terminal.

--]]

--------- Dependencies --------
local widgets = require "libs.widgets"

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

function display_logo(line)
    local logoName = "Home Monitor"
    local logoLen = string.len(logoName)
    local startX = (monitor.getSize() - logoLen) / 2

    monitor.setCursorPos(startX, line)
    monitor.blit(logoName, string.rep("2", logoLen), string.rep("7", logoLen))
end

function display_menu(line)
    monitor.setCursorPos(1, line)
    monitor.write("Menu:")
    monitor.setCursorPos(1, line + 1)
    monitor.write("> ")
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
        display_logo(3)
        display_menu(5)

        widgets.updateAll()
        widgets.displayAll(monitor)

        sleep(0.025)
    end
end


----------- Actions -----------
function toggle_door()
    redstone.setOutput("right", true)
    sleep(0.25)
    redstone.setOutput("right", false)
end

-------- Program Entry --------
widgets.createButton("[Toggle Cave Door]", 3, 6, toggle_door)

parallel.waitForAll(main_loop, handle_events)
