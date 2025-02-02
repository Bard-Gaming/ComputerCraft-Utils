--[[

App - UI library

UI App package.
Main interface for using this
library, as most processes start
here.

--]]

---------- Class Init ---------
local App = {
    scene = nil,
    screen = nil,
    isOpen = false,
    updateDelay = 0.05,  -- time the program sleeps before next iteration of mainloop
    events = {}
}


--------- App Creation --------
function App:new(screen)
    local newApp = {}

    setmetatable(newApp, self)
    self.__index = self

    newApp.super = self  -- useful for overrides
    newApp.screen = screen or term.native()

    return newApp
end


--------- App Process ---------
function App:update()
    if self.scene == nil then return end
    self.scene:update()
end

function App:display()
    if self.scene == nil then return end
    self.scene:display(self.screen)
end

function App:mainLoop()
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

function App:eventLoop()
    while self.isOpen do
        local eventData = { os.pullEventRaw() }  -- handle terminate ourselves
        local eventType = eventData[1]

        if self.events[eventType] ~= nil then
            self.events[eventType](self, eventData)  -- call the corresponding event function
        end
    end
end

function App:run()
    if self.scene == nil then
        printError("UI Lib: Warning: Running app without setting scene.")
    end

    self.isOpen = true
    parallel.waitForAll(function() self:mainLoop() end, function() self:eventLoop() end)
end


---------- App Events ---------
function App.events.terminate(app, eventData)
    app.isOpen = false
    app.screen.clear()
    printError("UILib: Terminated.")
end

function App.events.monitor_touch(app, eventData)
    if app.scene == nil then return end

    local x, y = eventData[3], eventData[4]

    app.scene:forEachWidget(function(widget)
        -- Call the button's click function if it is the element being clicked
        if widget:inWidget(x, y) and widget.type == "button" then
            widget:click()
            return false  -- stop iterating
        end

        return true  -- continue iterating
    end)
end


----------- Widgets -----------
function App:setScene(scene)
    if scene._isScene ~= true then
        error("UI Lib: Tried setting app scene to an invalid scene")
    end

    self.scene = scene
end


--------- Class Yield ---------
return App
