--[[

Button - UI Library

Implementation for Button
Widgets

--]]

--------- Dependencies --------
local Widget = require "libs.uilib.widgets.widget"


---------- Class Init ---------
local Button = Widget:new("button")


------- Button Creation -------
function Button:new(name, x, y, onclick)
    local nameLen = string.len(name)
    local newButton = {}

    setmetatable(newButton, self)
    self.__index = self

    newButton.name = name
    newButton.onClick = onclick or function() end

    -- Position:
    newButton.startX = x
    newButton.startY = y
    newButton.endX = x + string.len(name)
    newButton.endY = y

    -- Colors:
    newButton.defaultFg = string.rep("0", nameLen)
    newButton.defaultBg = string.rep("f", nameLen)

    newButton.activeFg = string.rep("0", nameLen)
    newButton.activeBg = string.rep("b", nameLen)

    newButton.fg = newButton.defaultFg
    newButton.bg = newButton.defaultBg

    -- Misc. Data:
    newButton.activeFrames = 0

    return newButton
end


-------- Button Process -------
function Button:update()
    if self.activeFrames == 0 then
        self.fg = self.defaultFg
        self.bg = self.defaultBg
    end

    if self.activeFrames > 0 then
        self.activeFrames = self.activeFrames - 1
    end
end

function Button:draw(screen)
    screen.setCursorPos(self.startX, self.startY)
    screen.blit(self.name, self.fg, self.bg)
end


-------- Button Events --------
function Button:click()
    -- Don't do anything if button has already been clicked
    if self.activeFrames > 0 then
        return
    end

    -- Update activeFrames and visuals, then call user onclick fnc
    self.activeFrames = 5
    self.fg = self.activeFg
    self.bg = self.activeBg
    self:onClick()
end


-------- Button Utility -------
local function colorToBlitStr(color, str)
    local colorChar = colors.toBlit(color)

    return string.rep(colorChar, string.len(str))
end

function Button:setName(name)
    local oldLen = string.len(self.name)
    local newLen = string.len(name)

    self.name = name

    -- Colors only need to be updated if there is a difference in length
    if oldLen == newLen then
        return
    end

    -- Update colors
    self.defaultFg = string.rep(string.sub(self.defaultFg, 1, 1), newLen)
    self.defaultBg = string.rep(string.sub(self.defaultBg, 1, 1), newLen)

    self.activeFg = string.rep(string.sub(self.activeFg, 1, 1), newLen)
    self.activeBg = string.rep(string.sub(self.activeBg, 1, 1), newLen)

    self.fg = string.rep(string.sub(self.fg, 1, 1), newLen)
    self.bg = string.rep(string.sub(self.bg, 1, 1), newLen)
end

function Button:setDefaultFGColor(color) self.defaultFg = colorToBlitStr(color, self.name) end
function Button:setDefaultBGColor(color) self.defaultBg = colorToBlitStr(color, self.name) end
function Button:setActiveFGColor(color)  self.activeFg  = colorToBlitStr(color, self.name) end
function Button:setActiveBGColor(color)  self.activeBg  = colorToBlitStr(color, self.name) end


--------- Class Yield ---------
return Button
