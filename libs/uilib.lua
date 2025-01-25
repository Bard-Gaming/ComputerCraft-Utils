--[[

UI Library

Library interface for easy
setup of ui library :>

--]]

---------- Interface ----------
local uilib = {}


------- Package Require -------
local uilibPath = ...
local globalRequire = require
require = function(path) return globalRequire(uilibPath .. "." .. path) end


----------- Packages ----------
uilib.app     =  require("app")
uilib.scene   =  require("scene")
uilib.widget  =  require("widgets.widget")
uilib.button  =  require("widgets.button")
uilib.text    =  require("widgets.text")


------------ Cleanup ----------
require = globalRequire  -- revert the require function so it works as intended


----------- Interface ---------
return uilib
