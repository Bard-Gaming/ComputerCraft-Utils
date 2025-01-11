--[[

Button - Widgets Library

Implementation for Button
widgets

--]]

--------- Dependencies --------
local wBase = require "libs.widgets.base"


--------- Global Vars ---------
local wButton = {}


------- Widget Creation -------
function wButton.create(name, x, y, onclick)
    local name_len = string.len(name)

    local button = wBase.createWidget(
        "button",           -- Type
        x, y,               -- start position
        x + name_len, y     -- end position
    )

    -- Add Button process
    button.update = wButton.update
    button.draw = wButton.draw
    button.activeFrames = 0
    button.fnc = onclick or function() end

    -- Label:
    button.name = name

    -- Colors:
    button.defaultFg = string.rep("0", name_len)
    button.activeFg = string.rep("0", name_len)

    button.defaultBg = string.rep("f", name_len)
    button.activeBg = string.rep("b", name_len)

    button.fg = button.defaultFg
    button.bg = button.defaultBg

    -- Add Button to list of Widgets:
    wBase.addWidget(button)

    return button
end


-------- Widget Process -------
function wButton.update(button)
    if button.activeFrames == 0 then
        button.fg = button.defaultFg
        button.bg = button.defaultBg
    end

    if button.activeFrames > 0 then
        button.activeFrames = button.activeFrames - 1
    end
end

function wButton.draw(button, screen)
    screen.setCursorPos(button.startX, button.startY)
    screen.blit(button.name, button.fg, button.bg)
end


-------- Widget Events --------
function wButton.click(button)
    -- Don't do anything if button has already been clicked
    if button.activeFrames > 0 then
        return
    end

    -- Update activeFrames and visuals, then call user onclick fnc
    button.activeFrames = 5
    button.fg = button.activeFg
    button.bg = button.activeBg
    button.fnc(button)
end

-------- Widget Utility -------
local function colorToBlitStr(color, length)
    local colorChar = colors.toBlit(color)
    return string.rep(colorChar, length)
end

function wButton.setName(button, name)
    local name_len = string.len(name)

    button.name = name

    -- Update Colors:
    button.defaultBg = string.rep(string.sub(button.defaultBg, 1, 1), name_len)
    button.activeBg = string.rep(string.sub(button.activeBg, 1, 1), name_len)

    button.fg = string.rep(string.sub(button.fg, 1, 1), name_len)
    button.bg = string.rep(string.sub(button.bg, 1, 1), name_len)
end

-- Button Colors:
function wButton.setDefaultFGColor(button, color) button.defaultFg = colorToBlitStr(color, string.len(button.name)) end
function wButton.setActiveFGColor(button, color) button.activeFg = colorToBlitStr(color, string.len(button.name)) end
function wButton.setDefaultBGColor(button, color) button.defaultBg = colorToBlitStr(color, string.len(button.name)) end
function wButton.setActiveBGColor(button, color) button.activeBg = colorToBlitStr(color, string.len(button.name)) end


return wButton
