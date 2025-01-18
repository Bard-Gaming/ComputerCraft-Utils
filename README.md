# ComputerCraft-Utils

Everything in this repo is to be used solely with [ComputerCraft: Tweaked](https://tweaked.cc/).
Whilst some parts may work with vanilla lua, it is not intended to be used that way.

That said, feel free to fork this repo / copy any of the code you see in this repo.

## UI Library

The UI Library allows you to easily create applications
with an interactive (animated) tty interface.

To get an app running in the terminal, all you need are the following lines:
```lua
local uilib = require "libs.uilib"

local app = uilib.app:new(term.native())  -- use the terminal's monitor for displaying

app:run()  -- loops until the app is supposed to stop
```

Note that, whilst the app is running, it isn't doing much, as there  is nothing
to show.

To get anything to show up on the screen, we first need a ``scene``.
To create a scene, let's add a few lines to our app:
```lua
local uilib = require "libs.uilib"

local app = uilib.app:new(term.native())
local scene = uilib.scene:new()  -- create a new scene to be used in our app

app:setScene(scene)  -- update the app's current scene
app:run()
```

Great! Now that we have a scene, we can actually start adding widgets and such to our app!
Let's add a button to our app:

```lua
local uilib = require "libs.uilib"

local app = uilib.app:new(term.native())
local scene = uilib.scene:new()
local button = uilib.button:new("[Cool Button]", 5, 3)  -- create at given position

scene:addWidget(button)

app:setScene(scene)
app:run()
```

This should be enough to get an app running that has a button, which automatically
detects when a user clicks on it (and plays a nice animation!).
Note that the colors that are used for the button can be changed anytime.
