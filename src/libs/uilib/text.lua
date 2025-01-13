--[[

Text - UI library

Implementation for Text
widget class

--]]

--------- Dependencies --------
local UIBase = require "libs.uilib.base"
local Widget = require "libs.uilib.widget"


---------- Class Init ---------
local Text = Widget:new("text")


------- Widget Creation -------
function Text:new(text, x, y)
    local new_text = {}

    setmetatable(new_text, self)

    -- Add Text Data:
    self.__index = self
    new_text.text = text
    new_text.startX = x
    new_text.startY = y
    new_text.endX = x + string.len(text)
    new_text.endY = y

    return new_text
end


----------- Process -----------
function Widget:update()

end

function Widget:draw(screen)
    screen.setCursorPos(self.startX, self.startY)
    screen.write(self.text)
end


--------- Class Yield ---------
return Widget
