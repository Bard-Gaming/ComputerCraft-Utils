--[[

Text - UI library

Implementation for Text
widget class

--]]

--------- Dependencies --------
local Widget = require "libs.uilib.widgets.widget"


---------- Class Init ---------
local Text = Widget:new("text")


------- Widget Creation -------
function Text:new(text, x, y)
    local new_text = {}

    setmetatable(new_text, self)
    self.__index = self

    -- Add Text Data:
    new_text.text = text
    new_text.alignment = "left"
    new_text.width = string.len(text)
    new_text.startX = x or 0
    new_text.startY = y or 0
    new_text.endX = new_text.startX + new_text.width
    new_text.endY = y

    return new_text
end


----------- Position ----------
function Text:alignLeft()
    if self.alignment == "left" then return end

    if self.alignment == "center" then
        local offset = math.floor(self.width / 2)
        self.startX = self.startX + offset
        self.endX = self.endX + offset

    elseif self.alignment == "right" then
        self.startX = self.endX
        self.endX = self.endX + self.width

    end

    self.alignment = "left"
end

function Text:alignCenter()
    if self.alignment == "center" then return end
    self:alignLeft()  -- reset alignment

    local offset = math.floor(self.width / 2)
    self.startX = self.startX - offset
    self.endX = self.endX - offset

    self.alignment = "center"
end

function Text:alignRight()
    if self.alignment == "right" then return end
    self:alignLeft()  -- reset alignment

    self.endX = self.startX
    self.startX = self.startX - self.width

    self.alignment = "right"
end


----------- Process -----------
function Text:update()

end

function Text:draw(screen)
    screen.setCursorPos(self.startX, self.startY)
    screen.write(self.text)
end


--------- Text Utility --------
function Text:setText(text)
    local alignment = self.alignment
    self:alignLeft()  -- reset alignment

    self.text = text
    self.width = string.len(text)
    self.endX = self.startX + self.width

    -- Restore alignment
    if alignment == "center" then
        self:alignCenter()
    elseif alignment == "right" then
        self:alignRight()
    end
end


--------- Class Yield ---------
return Text
