--[[

Base - UI library

UI Base package.
Handles UI process, as
well as providing some
shared utilities.

--]]

--------- Package Init --------
local UIBase = {
    _buffer = {},
    _count = 0,
    _screen = nil,
    _customDisplay = nil,
    isOpen = false
}


-------- Widget Process -------
function UIBase.addWidget(widget)
    -- Check if widget is an actual widget
    if not widget._isWidget then
        printError("UI Lib: Tried adding value that isn't a widget")
        return
    end

    -- Add widget to widget buffer
    UIBase._count = UIBase._count + 1
    UIBase._buffer[UIBase._count] = widget
end

function UIBase.hijackDisplay(displayFnc)
    UIBase._customDisplay = displayFnc
end


------- Helper Functions ------
local function handleTouch(x, y)
    local lastWidget = nil

    for _, widget in ipairs(UIBase._buffer) do
        if widget:inWidget(x, y) and widget.type == "button" then
            lastWidget = widget
        end
    end

    if lastWidget == nil then
        return
    end

    lastWidget:click()  -- Only click the last widget (frontmost widget)
end


-------- Widget Process -------
function UIBase.updateAll()
    for _, widget in ipairs(UIBase._buffer) do
        widget:update()
    end
end

function UIBase.displayAll(screen)
    for _, widget in ipairs(UIBase._buffer) do
        widget:draw(screen)
    end
end

function UIBase.appMainLoop(screen)
    screen = screen or UIBase._screen  -- Use UIBase._screen as fallback
    UIBase.isOpen = true

    if screen == nil then
        printError("UI Lib: Tried running main loop without valid screen")
        return
    end

    while UIBase.isOpen do
        -- State Update
        UIBase.updateAll()

        -- Display
        screen.clear()
        if UIBase._customDisplay ~= nil then UIBase._customDisplay(screen) end
        UIBase.displayAll(screen)

        sleep(0.05)
    end

    screen.clear()
end

function UIBase.appEventLoop()
    while true do
        local eventData = { os.pullEventRaw() }
        local type = eventData[1]

        if type == "monitor_touch" then
            handleTouch(eventData[3], eventData[4])
        elseif type == "terminate" then
            UIBase.isOpen = false -- Gracefully exit
        end
    end
end


-------- Package Yield --------
return UIBase
