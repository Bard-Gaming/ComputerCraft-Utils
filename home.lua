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

disk_drive = peripheral.wrap("right")

app = uilib.app:new(monitor)


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
    if app.scene == app.main_scene then
        display_time(1)
        display_logo(3)
        display_menu(6)
    end
    app.super.display(app)
end


------------ Events -----------
function update_music_display(app)
    local music_text = app.scene.widgetBuffer[4]

    music_text:setText(disk_drive.getAudioTitle() or "Insert Music Disc")
end

app.events.disk = update_music_display
app.events.disk_eject = update_music_display


------------ Rednet -----------
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
function toggle_music(button)
    if not disk_drive.hasAudio() then return end

    button.is_on = not button.is_on  -- update state

    if button.is_on then
        disk_drive.playAudio()
        button:setName("||")
    else
        disk_drive.stopAudio()
        button:setName("|>")
    end
end


--------- Menu Buttons --------
local MenuButton = uilib.button:new(".", 0, 0)

function MenuButton:new(name, hostname, x, y)
    local newButton = {}

    setmetatable(newButton, self)
    self.__index = self

    newButton.startX = x
    newButton.startY = y
    newButton.endX = x + string.len(name)
    newButton.endY = y

    newButton:setName(name)
    newButton.hostname = hostname
    newButton:updateDisplayDynamic()

    return newButton
end

function MenuButton:onClick()
    -- Component Controller:
    local controller = rednet.lookup("home_control", self.hostname)
    if controller == nil then
        printError("Rednet: controller \"" .. self.hostname .. "\" not found")
        return
    end

    -- Send Message to controller and update button with new state:
    rednet.send(controller, "toggle", "home_control")
    self:updateDisplayDynamic()
end

function MenuButton:queryState()
    local controller = rednet.lookup("home_control", self.hostname)

    if controller == nil then
        printError("Rednet: Controller for \"" .. self.hostname .. "\" not found")
        return
    end

    -- Send get request:
    rednet.send(controller, "state", "home_control")

    -- Retrieve message:
    local _, state = rednet.receive("home_control", 1)
    state = state or "no response"

    -- Handle invalid message:
    if state ~= "on" and state ~= "off" then
        printError("Rednet: Unrecognized state (\"" .. state .. "\")")
        return nil
    end

    -- Return boolean representation of value
    return state == "on"
end

function MenuButton:updateDisplayDynamic()  -- Update display by querying state
    local isEnabled = self:queryState()

    -- If an invalid state is received, don't do anything (error already displayed)
    if isEnabled == nil then
        return
    end

    local newColor = isEnabled and colors.lime or colors.red  -- lime if enabled, else red

    self:setDefaultFGColor(newColor)
end


-------- Program Setup --------
-- Initialize Rednet
rednet.open("back")
rednet.host("home_control", "root")


-- Menu
local power_btn = uilib.button:new("[@]", 50, 24, toggle_power)

local doorButton = MenuButton:new("[Basement Door]", "basement_door", 3, 7)
local mobButton = MenuButton:new("[Mob Spawners]", "mob_spawners", 3, 8)
local rocketButton = MenuButton:new("[Rocket Exit]", "rocket_door", 3, 9)


-- Music
local music_display = uilib.text:new("unknown", 45, 7)
music_display:alignCenter()
music_display:setText(disk_drive.getAudioTitle() or "Insert Music Disc")

local music_btn = uilib.button:new("|>", 45, 9, toggle_music)
music_btn.is_on = false


-- Main Scene
app.main_scene = uilib.scene:new()

app.main_scene:addWidget(power_btn)
app.main_scene:addWidget(doorButton)
app.main_scene:addWidget(mobButton)
app.main_scene:addWidget(rocketButton)
app.main_scene:addWidget(music_display)
app.main_scene:addWidget(music_btn)


-- Off Scene
app.off_scene = uilib.scene:new()

app.off_scene:addWidget(power_btn)


-- Run App
app:setScene(app.off_scene)
app:run()
