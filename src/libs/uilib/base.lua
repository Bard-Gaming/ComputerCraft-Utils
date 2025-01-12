--[[

Base - UI library

UI Base package.
Handles UI process, as
well as providing some
shared utilities.

--]]

--------- Package Init --------
local UIBase = { _buffer = {}, _count = 0 }


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


--------------------------------------------------------
function UIBase.forEach(fnc)
    for _, widget in ipairs(UIBase._buffer) do
        fnc(widget)
    end
end


-------- Package Yield --------
return UIBase
