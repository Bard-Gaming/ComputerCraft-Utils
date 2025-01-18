--[[

Scene - UI library

UI Scene package.
Manage scenes, which are the
containers of widgets, and can
be switched easily.

--]]

---------- Class Init ---------
local UIScene = {
    widgetBuffer = nil,
    widgetCount = nil,
    _isScene = true
}


-------- Scene Creation -------
function UIScene:create()
    local new_scene = {}

    setmetatable(new_scene, self)
    self.__index = self

    new_scene.widgetBuffer = {}
    new_scene.widgetCount = 0
    return new_scene
end


----------- Process -----------
function UIScene:update()
    for _, widget in ipairs(self.widgetBuffer) do
        widget:update()  -- assumes all tables in widgetBuffer are widgets
    end
end

function UIScene:display(screen)
    for _, widget in ipairs(self.widgetBuffer) do
        widget:draw(screen)  -- assumes all tables in widgetBuffer are widgets
    end
end


----------- Widgets -----------
function UIScene:addWidget(widget)
    -- Check if widget is valid
    if not widget._isWidget then
        error("UI Lib: Error: Tried adding invalid widget to scene")
    end

    -- Add widget to widget buffer
    self.widgetCount = self.widgetCount + 1
    self.widgetBuffer[self.widgetCount] = widget
end


--------- Class Yield ---------
return UIScene
