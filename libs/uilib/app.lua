--[[

App - UI library

UI App package.
Main interface for using this
library, as most processes start
here.

--]]

---------- Class Init ---------
local UIApp = {
    widgetBuffer = {},
    widgetCount = 0,
    screen = nil,
    isOpen = false,
    updateDelay = 0.05,  -- time the program sleeps before next iteration of mainloop
    events = {}
}


--------- App Creation --------
function UIApp:create(screen)
    local app = {}

    setmetatable(app, self)
    self.__index = self
    app.super = self  -- useful for overrides

    app.screen = screen or term.native()

    return app
end


--------- App Process ---------
function UIApp:update()
    for _, widget in ipairs(self.widgetBuffer) do
        widget:update()  -- assumes all tables in widgetBuffer are widgets
    end
end

function UIApp:display()
    for _, widget in ipairs(self.widgetBuffer) do
        widget:draw(self.screen)  -- assumes all tables in widgetBuffer are widgets
    end
end

function UIApp:mainLoop()
    while self.isOpen do
        -- Update State
        self:update()

        -- Draw everything on the screen
        self.screen.clear()
        self.display()

        -- Sleep
        sleep(self.udpateDelay)
    end

    screen.clear()
end

function UIApp:eventLoop()
    while self.isOpen do
        local eventData = { os.pullEventRaw() }  -- handle terminate ourselves
        local eventType = eventData[1]

        if self.events[eventType] ~= nil then
            self.events[eventType](self, eventData)  -- call the corresponding event function
        end
    end
end

function UIApp:run()
    self.isOpen = true

    parallel.waitForAll(function() self:mainLoop() end, function() self:eventLoop() end)
end


---------- App Events ---------
function UIApp.events.terminate(app, eventData)
    app.isOpen = false
    app.screen.clear()
    printError("UILib: Terminated.")
end

function UIApp.events.monitor_touch(app, eventData)
    local x, y = eventData[3], eventData[4]
    local lastWidget = nil

    for _, widget in ipairs(app.widgetBuffer) do
        if widget:inWidget(x, y) and widget.type == "button" then
            lastWidget = widget
        end
    end

    if lastWidget == nil then return end

    lastWidget:click()  -- Only click the last widget (frontmost widget)
end


----------- Widgets -----------
function UIApp:addWidget(widget)
    -- Check if widget is an actual widget
    if not widget._isWidget then
        printError("UI Lib: Tried adding value that isn't a widget")
        return  -- continue with warning
    end

    -- Add widget to widget buffer
    self.widgetCount = self.widgetCount + 1
    self.widgetBuffer[self.widgetCount] = widget
end


--------- Class Yield ---------
return UIApp
