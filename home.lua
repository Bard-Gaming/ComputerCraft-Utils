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
    for i=1, 3 do
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


------------ Rednet -----------
function rednet_init()
    rednet.open("back")
    rednet.host("home_control", "root")
end

function rednet_get_state(hostname)
    local controller = rednet.lookup("home_control", hostname)
    if controller == nil then
        printError("Rednet: Controller not found")
        return
    end

    -- Send get request:
    rednet.send(controller, "state", "home_control")

    -- Handle received message:
    local _, state = rednet.receive("home_control", 1)
    state = state or "unknown"

    -- Return result:
    if state == "on" then
        return true
    elseif state == "off" then
        return false
    else
        printError("Rednet: Unrecognized message \"" .. state .. "\"")
        return
    end
end


----------- Actions -----------
function update_button_display(button, hostname)
    local isOpen = rednet_get_state(hostname)
    if isOpen == nil then
        return  -- propagate error
    end

    -- Update logic:
    if isOpen then
        button:setDefaultFGColor(colors.lime)
    else
        button:setDefaultFGColor(colors.red)
    end
end

function toggle_door(button)
    -- Door Controller:
    local doorController = rednet.lookup("home_control", "basement_door")
    if doorController == nil then
        printError("Rednet: Door Controller not found")
        return
    end

    -- Send Message to door controller and update button with new state:
    rednet.send(doorController, "toggle", "home_control")
    update_button_display(button, "basement_door")
end

function toggle_mobs(button)
    -- Spawner Controller:
    local spawnerController = rednet.lookup("home_control", "mob_spawners")
    if spawnerController == nil then
        printError("Rednet: Spawner Controller not found")
        return
    end

    -- Send Message to spawner controller and update button with new state:
    rednet.send(spawnerController, "toggle", "home_control")
    update_button_display(button, "mob_spawners")
end

function toggle_rocket(button)
    -- Rocket Controller:
    local spawnerController = rednet.lookup("home_control", "rocket_door")
    if spawnerController == nil then
        printError("Rednet: Rocket Controller not found")
        return
    end

    -- Send Message to rocket controller and update button with new state:
    rednet.send(spawnerController, "toggle", "home_control")
    update_button_display(button, "rocket_door")
end


-------- Program Setup --------
rednet_init()

local door_btn = uilib.button:new("[Basement Door]", 3, 7, toggle_door)
update_button_display(door_btn, "basement_door")
app:addWidget(door_btn)

local mob_btn = uilib.button:new("[Mob Spawners]", 3, 8, toggle_mobs)
update_button_display(mob_btn, "mob_spawners")
app:addWidget(mob_btn)

local rocket_btn = uilib.button:new("[Rocket Exit]", 3, 9, toggle_rocket)
update_button_display(rocket_btn, "rocket_door")
app:addWidget(rocket_btn)

app:run()
