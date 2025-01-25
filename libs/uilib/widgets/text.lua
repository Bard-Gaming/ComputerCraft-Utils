--[[

Text - UI library

Implementation for Text
widget class

--]]

--------- Dependencies --------
local Position = require "types.position"
local Widget = require "widgets.widget"


---------- Class Init ---------
local Text = Widget:new("text")


------- Widget Creation -------
function Text:new(text, x, y)
    local newText = {}

    setmetatable(newText, self)
    self.__index = self

    -- Add Text Data:
    newText.text = text
    newText.alignment = "left"
    newText.position = Position:new(x, y, string.len(text), 0)

    return newText
end


----------- Process -----------
function Text:update()

end

function Text:draw(screen)
    screen.setCursorPos(self.position.startX, self.position.startY)
    screen.write(self.text)
end


--------- Text Utility --------
function Text:setText(text)
    self.text = text
    self.position:setSize(string.len(text))
end


--------- Class Yield ---------
return Text
