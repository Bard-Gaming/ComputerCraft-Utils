--[[

Home program.

This program displays a simple window
with some rudimentary applications. 

It is ideally used with a monitor,
but can also be used for a terminal.

--]]

--------- Dependencies --------
local uilib = require "libs.uilib"


--------- Global Vars ---------
monitor = peripheral.wrap("left")
monitor.setTextScale(0.5)

app = uilib.app:create(monitor)


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
    local startX = (monitor.getSize() - logoLen) / 2 + 1

    monitor.setCursorPos(startX, line)
    monitor.blit(logoName, string.rep("2", logoLen), string.rep("7", logoLen))
end

function display_menu(line)
    monitor.setCursorPos(1, line)
    monitor.write("Menu:")
    for i=1, 2 do
        monitor.setCursorPos(1, line + i)
        monitor.write("> ")
    end
end


function app:display(screen)
    display_time(1)
    display_logo(3)
    display_menu(6)
    app.super.display(app)
end


----------- Actions -----------
function toggle_door(button)
    if button.isEnabled then
        button:setDefaultFGColor(colors.red)
        button.isEnabled = false
    else
        button:setDefaultFGColor(colors.lime)
        button.isEnabled = true
    end

    redstone.setOutput("right", true)
    sleep(0.25)
    redstone.setOutput("right", false)
end

function toggle_mobs(button)
    if button.isEnabled then
        button:setDefaultFGColor(colors.red)
        button.isEnabled = false
    else
        button:setDefaultFGColor(colors.lime)
        button.isEnabled = true
    end

    redstone.setOutput("back", true)
    sleep(0.25)
    redstone.setOutput("back", false)
end


-------- Program Setup --------
local door_btn = uilib.button:new("[Basement Door]", 3, 7, toggle_door)
door_btn:setDefaultFGColor(colors.red)
door_btn.isEnabled = false;
app:addWidget(door_btn)


local mob_btn = uilib.button:new("[Mob Spawners]", 3, 8, toggle_mobs)
mob_btn:setDefaultFGColor(colors.red)
mob_btn.isEnabled = false
app:addWidget(mob_btn)


app:run()
