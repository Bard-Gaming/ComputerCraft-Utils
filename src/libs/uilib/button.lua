--[[

Button - UI Library

Implementation for Button
Widgets

--]]

--------- Dependencies --------
local UIBase = require "libs.uilib.base"
local Widget = require "libs.uilib.widget"


---------- Class Init ---------
local Button = Widget:new("button")


------- Button Creation -------
function Button:new(name, x, y, onclick)
    local name_len = string.len(name)
    local new_button = {}

    setmetatable(new_button, self)

    self.__index = self
    new_button.name = name
    new_button.onClick = onclick or function() end

    -- Position:
    new_button.startX = x
    new_button.startY = y
    new_button.endX = x + string.len(name)
    new_button.endY = y

    -- Colors:
    new_button.defaultFg = string.rep("0", name_len)
    new_button.defaultBg = string.rep("f", name_len)

    new_button.activeFg = string.rep("0", name_len)
    new_button.activeBg = string.rep("b", name_len)

    new_button.fg = new_button.defaultFg
    new_button.bg = new_button.defaultBg

    -- Misc. Data:
    new_button.activeFrames = 0

    -- Add button to screen:
    UIBase.addWidget(new_button)

    return new_button
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
    local old_len = string.len(self.name)
    local new_len = string.len(name)

    self.name = name

    -- Colors only need to be updated if there is a difference in length
    if old_len == new_len then
        return
    end

    -- Update colors
    self.defaultFg = string.rep(string.sub(self.defaultFg, 1, 1), new_len)
    self.defaultBg = string.rep(string.sub(self.defaultBg, 1, 1), new_len)

    self.activeFg = string.rep(string.sub(self.activeFg, 1, 1), new_len)
    self.activeBg = string.rep(string.sub(self.activeBg, 1, 1), new_len)

    self.fg = string.rep(string.sub(self.fg, 1, 1), new_len)
    self.bg = string.rep(string.sub(self.bg, 1, 1), new_len)
end

function Button:setDefaultFGColor(color) self.defaultFg = colorToBlitStr(color, self.name) end
function Button:setDefaultBGColor(color) self.defaultBg = colorToBlitStr(color, self.name) end
function Button:setActiveFGColor(color)  self.activeFg  = colorToBlitStr(color, self.name) end
function Button:setActiveBGColor(color)  self.activeBg  = colorToBlitStr(color, self.name) end


--------- Class Yield ---------
return Button
