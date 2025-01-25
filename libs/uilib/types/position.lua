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
function Position:new(x, y, width, height)
    local newPosition = {}

    setmetatable(newPosition, self)
    self.__index = self

    -- Add Position Data:
    newPosition.startX = x or 0
    newPosition.startY = y or 0
    newPosition.endX = newPosition.startX + (width or 0)
    newPosition.endY = newPosition.startY + (height or 0)
    newPosition.alignment = "left"

    return newPosition
end


----------- Utility -----------
function Position:isInside(x, y)
    return
        self.startX <= x and x <= self.endX and
        self.startY <= y and y <= self.endY
end

function Position:setAlignment(alignment)
    local alignmentTable = {
        left = self.alignLeft,
        center = self.alignCenter,
        right = self.alignRight,
    }

    alignmentTable[alignment or "left"](self)  -- call corresponding alignment function
end

function Position:setSize(width, height)
    local alignment = self.alignment
    self:alignLeft()  -- (temporarily) reset the alignment

    self.endX = self.startX + width

    if height ~= nil then
        self.endY = self.startY + height
    end

    self:setAlignment(alignment)
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

    local width = self.endX - self.startX
    local offset = math.floor(width / 2)

    self.startX = self.startX - offset
    self.endX = self.endX - offset

    self.alignment = "center"
end

function Position:alignRight()
    if self.alignment == "right" then return end
    self:alignLeft()  -- reset alignment

    local width = self.endX - self.startX

    self.endX = self.startX
    self.startX = self.startX - width

    self.alignment = "right"
end


--------- Class Yield ---------
return Position
