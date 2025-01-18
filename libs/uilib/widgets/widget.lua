--[[

Widget - UI library

Implementation for Widget
Base Class

--]]

---------- Class Init ---------
local Widget = { _isWidget = true }  -- mark widget table for error handling


------- Widget Creation -------
function Widget:new(type, startX, startY, endX, endY)
    local new_widget = {}

    setmetatable(new_widget, self)

    -- Add Widget Data:
    self.__index = self
    new_widget.type = type or "generic"
    new_widget.startX = startX or 0
    new_widget.startY = startY or 0
    new_widget.endX = endX or 0
    new_widget.endY = endY or 0

    return new_widget
end


----------- Process -----------
function Widget:update()

end

function Widget:draw(screen)

end


----------- Utility -----------
function Widget:inWidget(x, y)
    return
        self.startX <= x and x <= self.endX and
        self.startY <= y and y <= self.endY
end


--------- Class Yield ---------
return Widget
