--[[

Base - Wigets library

Implementation for Base
widgets

--]]

--------- Global Vars ---------
local wBase = {}
wBase._buffer = {}
wBase._count = 0


-------- Widget Process -------
function wBase.updateAll()
    for _, widget in ipairs(wBase._buffer) do
        widget.update(widget)
    end
end

function wBase.displayAll(screen)
    for _, widget in ipairs(wBase._buffer) do
        widget.draw(widget, screen)
    end
end


----------- Utility -----------
function wBase.inWidget(x, y, widget)
    return
        widget.startX <= x and x <= widget.endX and
        widget.startY <= y and y <= widget.endY
end

function wBase.forEach(fnc)
    for _, widget in ipairs(wBase._buffer) do
        fnc(widget)
    end
end

------- Widget Creation -------
function wBase.createWidget(type, startX, startY, endX, endY)
    local widget = {}

    -- Add Widget Data:
    widget.type = type
    widget.startX = startX
    widget.startY = startY
    widget.endX = endX
    widget.endY = endY

    -- Add default draw and update functions (prevents errors)
    widget.draw = function() end
    widget.update = function() end

    return widget
end

function wBase.addWidget(widget)
    wBase._count = wBase._count + 1
    wBase._buffer[wBase._count] = widget
end


return wBase
