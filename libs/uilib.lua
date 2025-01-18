--[[

UI Library

Library interface for easy
setup of ui library :>

--]]

---------- Interface ----------
local uilib = {}


---------- Variables ----------
local uilibPath = ...


----------- Packages ----------
uilib.app     =  require(uilibPath .. ".app")
uilib.scene   =  require(uilibPath .. ".scene")
uilib.widget  =  require(uilibPath .. ".widgets.widget")
uilib.button  =  require(uilibPath .. ".widgets.button")
uilib.text    =  require(uilibPath .. ".widgets.text")


----------- Interface ---------
return uilib
