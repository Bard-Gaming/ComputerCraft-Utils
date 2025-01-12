--[[

UI Library

Library interface for easy
setup of ui library :>

--]]

----------- Interface ---------
local uilib = {}


----------- Packages ----------
uilib.base = require "libs.uilib.base"
uilib.widget = require "libs.uilib.widget"
uilib.button = require "libs.uilib.button"


------ Utility Functions ------
function uilib.run(screen)
    uilib.base._screen = screen  -- set up fallback screen

    parallel.waitForAll(uilib.base.appMainLoop, uilib.base.appEventLoop)
end


----------- Interface ---------
return uilib
