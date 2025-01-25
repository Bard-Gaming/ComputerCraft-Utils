--[[

Widget - UI library

Implementation for Widget
Base Class

--]]

---------- Class Init ---------
local Position = require "types.position"
local Widget = { _isWidget = true }  -- mark widget table for error handling


------- Widget Creation -------
function Widget:new(type, x, y, width, height)
    local newWidget = {}

    setmetatable(newWidget, self)
    self.__index = self

    -- Add Widget Data:
    newWidget.type = type or "generic"
    newWidget.position = Position:new(x, y, width, height)

    return newWidget
end


----------- Process -----------
function Widget:update()

end

function Widget:draw(screen)

end


----------- Utility -----------
function Widget:inWidget(x, y)
    return self.position:isInside(x, y)
end


--------- Class Yield ---------
return Widget
