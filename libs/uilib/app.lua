--[[

App - UI library

UI App package.
Main interface for using this
library, as most processes start
here.

--]]

---------- Class Init ---------
local UIApp = {
    scene = nil,
    screen = nil,
    isOpen = false,
    updateDelay = 0.05,  -- time the program sleeps before next iteration of mainloop
    events = {}
}


--------- App Creation --------
function UIApp:new(screen)
    local app = {}

    setmetatable(app, self)
    self.__index = self

    app.super = self  -- useful for overrides
    app.screen = screen or term.native()

    return app
end


--------- App Process ---------
function UIApp:update()
    if self.scene == nil then return end
    self.scene:update()
end

function UIApp:display()
    if self.scene == nil then return end
    self.scene:display(self.screen)
end

function UIApp:mainLoop()
    while self.isOpen do
        -- Update State
        self:update()

        -- Draw everything on the screen
        self.screen.clear()
        self:display()

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
    if self.scene == nil then
        printError("UI Lib: Warning: Running app without setting scene.")
    end

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
    if app.scene == nil then return end

    local x, y = eventData[3], eventData[4]
    local lastWidget = nil

    for _, widget in ipairs(app.scene.widgetBuffer) do
        if widget:inWidget(x, y) and widget.type == "button" then
            lastWidget = widget
        end
    end

    if lastWidget == nil then return end

    lastWidget:click()  -- Only click the last widget (frontmost widget)
end


----------- Widgets -----------
function UIApp:setScene(scene)
    if scene._isScene ~= true then
        error("UI Lib: Tried setting app scene to an invalid scene")
    end

    self.scene = scene
end


--------- Class Yield ---------
return UIApp
