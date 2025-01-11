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
    button.defaultBg = string.rep("f", name_len)
    button.activeBg = string.rep("b", name_len)
    
    button.fg = string.rep("0", name_len)
    button.bg = button.defaultBg

    -- Add Button to list of Widgets:
    wBase.addWidget(button)

    return button
end


-------- Widget Process -------
function wButton.update(button)
    if button.activeFrames > 0 then
        button.activeFrames = button.activeFrames - 1

        if button.activeFrames == 0 then
            button.bg = button.defaultBg
        end
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
    button.bg = button.activeBg
    button.fnc(button)
end

-------- Widget Utility -------
function wButton.setDefaultColor(button, color)
    local colorChar = colors.toBlit(color)

    button.defaultBg = string.rep(colorChar, string.len(button.name))
end

function wButton.setActiveColor(button, color)
    local colorChar = colors.toBlit(color)

    button.activeBg = string.rep(colorChar, string.len(button.name))
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


return wButton
