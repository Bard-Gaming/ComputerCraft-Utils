--[[

Wigets library

This lua program can be used
to create widgets, which are
practical when making user
interfaces.

--]]

--------- Global Vars ---------
local widgets = {}
widgets._buffer = {}
widgets._count = 0


-------- Widget Process -------
function widgets.updateAll()
    for _, widget in ipairs(widgets._buffer) do
        widget.update(widget)
    end
end

function widgets.displayAll(screen)
    for _, widget in ipairs(widgets._buffer) do
        widget.draw(widget, screen)
    end
end


----------- General -----------
function widgets.inWidget(x, y, widget)
    return
        widget.startX <= x and x <= widget.endX and
        widget.startY <= y and y <= widget.endY
end

function widgets.forEach(fnc)
    for _, widget in ipairs(widgets._buffer) do
        fnc(widget)
    end
end

----------- Buttons -----------
function widgets.createButton(name, x, y, onclick)
    local button = {}
    local name_len = string.len(name)

    -- Create Button:
    button.type = "button"
    button.update = widgets.updateButton
    button.draw = widgets.drawButton
    button.activeFrames = 0

    button.startX = x
    button.startY = y
    button.endX = x + name_len
    button.endY = y

    button.name = name
    button.fg = string.rep("0", name_len)
    button.bg = string.rep("f", name_len)
    button.fnc = onclick or function() end

    -- Add Button to Widget list:
    widgets._count = widgets._count + 1
    widgets._buffer[widgets._count] = button

    return button
end

function widgets.updateButton(button)
    if button.activeFrames > 0 then
        button.activeFrames = button.activeFrames - 1

        if button.activeFrames == 0 then
            button.bg = string.rep("f", string.len(button.name))
        end
    end
end

function widgets.drawButton(button, screen)
    screen.setCursorPos(widget.startX, widget.startY)
    screen.blit(widget.name, widget.fg, widget.bg)
end

function widgets.clickButton(button)
    -- Don't do anything if button has already been clicked
    if button.activeFrames > 0 then
        return
    end

    -- Update activeFrames and visuals, then call user onclick fnc
    button.activeFrames = 5
    button.bg = string.rep("b", string.len(button.name))
    button.fnc()
end


return widgets
