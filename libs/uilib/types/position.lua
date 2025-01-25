--[[

Position Type - UI library

Implementation for Position
class

--]]

---------- Class Init ---------
local Position = {
    startX = 0,
    startY = 0,
    endX = 0,
    endY = 0,
    alignment = "left"
}


------- Widget Creation -------
function Position:new(startX, startY, endX, endY)
    local newPosition = {}

    setmetatable(newPosition, self)
    self.__index = self

    -- Add Position Data:
    newPosition.startX = startX
    newPosition.startY = startY
    newPosition.endX = endX
    newPosition.endY = endY
    newPosition.alignment = "left"

    return newPosition
end


----------- Utility -----------
function Position:isInside(x, y)
    return
        self.startX <= x and x <= self.endX and
        self.startY <= y and y <= self.endY
end


---------- Alignment ----------
function Position:alignLeft()
    if self.alignment == "left" then return end
    local width = self.endX - self.startX

    if self.alignment == "center" then
        local offset = math.floor(width / 2)
        self.startX = self.startX + offset
        self.endX = self.endX + offset

    elseif self.alignment == "right" then
        self.startX = self.endX
        self.endX = self.endX + width

    end

    self.alignment = "left"
end

function Position:alignCenter()
    if self.alignment == "center" then return end
    self:alignLeft()  -- reset alignment

    local offset = math.floor(width / 2)
    self.startX = self.startX - offset
    self.endX = self.endX - offset

    self.alignment = "center"
end

function Position:alignRight()
    if self.alignment == "right" then return end
    self:alignLeft()  -- reset alignment

    self.endX = self.startX
    self.startX = self.startX - self.width

    self.alignment = "right"
end


--------- Class Yield ---------
return Position
