--[[

Base - Wigets library

Package base; manages main
library pipeline, as well
as some other things.

--]]

--------- Package Init --------
local wBase = { _buffer = {}, _count = 0 }


-------- Widget Process -------
function wBase.addWidget(widget)
    -- Check if widget is an actual widget
    if not widget._isWidget then
        printError("UI Lib: Tried adding value that isn't a widget")
        return
    end

    -- Add widget to widget buffer
    wBase._count = wBase._count + 1
    wBase._buffer[wBase._count] = widget
end

function wBase.updateAll()
    for _, widget in ipairs(wBase._buffer) do
        widget:update()
    end
end

function wBase.displayAll(screen)
    for _, widget in ipairs(wBase._buffer) do
        widget:draw(screen)
    end
end


--------------------------------------------------------
function wBase.forEach(fnc)
    for _, widget in ipairs(wBase._buffer) do
        fnc(widget)
    end
end


-------- Package Yield --------
return wBase
