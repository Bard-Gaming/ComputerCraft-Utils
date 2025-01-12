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


----------- Interface ---------
return uilib
