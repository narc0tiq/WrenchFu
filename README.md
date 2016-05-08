This is a [Factorio](http://www.factorio.com/) mod. It adds a wrench item that
can be used to trigger custom GUIs on machines of mods that support it.


## Usage ##

WrenchFu, by itself, does only one player-visible thing: it adds a wrench item
and a recipe to craft it. If no other mod is installed that uses WrenchFu,
the wrench is basically useless and you shouldn't craft it. However...

...If another mod (or mods) are installed that are compatible with WrenchFu, then
clicking one of their machines with the wrench item in hand will result in
opening that machine's custom interface and allowing you to configure its
deeper aspects.

When you walk away from a machine you wrenched open, the mod will also make
sure to close the custom interface so that it doesn't get in your way.


## Integrating ##

So, you wanna use WrenchFu on your machines? Not much to it:

- your mod should depend on WrenchFu (optionally or not, depending on whether
your mod could run without the wrenchability). This goes in your info.json, and
ensures your mod loads after WrenchFu:

```JSON
{
    "name": "My-Awesome-Mod",
    "version": "1.0.0",
    [...]
    "dependencies": ["base >= 0.12.0", "? WrenchFu"]
}
```

- your mod needs to have a remote interface, defining at least two functions:

```Lua
local interface = {}

function interface.show_my_gui(player_index, entity_name, position)
    -- Do stuff here to show your GUI; anything you like!
end
--[[
    alternately, this could be:
        function interface.show_my_gui(player, entity)
    by changing some options you'll see below.
]]

function interface.hide_my_gui(player_index, entity_name, position)
    -- Do stuff here to hide your GUI; again, anything you like!
end

remote.add_interface("My-Mod-Interface", interface)
```

(I suppose technically you could have a single function, but then you'd have to
 remember if the GUI was supposed to be shown or hidden or not, and it would
 suck if your internal state got out of sync with what the player expected.)


- finally, and most importantly, your mod needs to register with WrenchFu
whenever it runs (the registry is not persistent, similar to how
`remote.add_interface` is non-persistent):

```Lua
remote.call("WrenchFu", "register", "my-machine-name", "My-Mod-Interface", "show_my_gui", "hide_my_gui")
```

When registering, you can also pass in a table of options to configure how you
want WrenchFu to act:
```Lua
local options = {
    -- change how far "too far to remain open" is for your GUI:
    proximity_distance = 12,

    -- ask for an entity reference instead of name and position to be passed to your
    -- show_function:
    wants_entity = true,

    -- ask for a player reference instead of a player index to be passed to
    -- your show_function:
    wants_player = true,
}

remote.call("WrenchFu", "register", "some-machine", "My-Mod-Interface", "show_my_gui", "hide_my_gui", options)
```

You may also replace the "hide\_my\_gui" function with a nil, if you don't need it:

```Lua
remote.call("WrenchFu", "register", "some-other-machine", "My-Mod-Interface", "show_my_gui", nil, options)
```

You should note that only one handler can be registered for any given machine,
but that the same handler can be registered to multiple machines, if that's
useful to you (e.g., if you have several tiers of mining drill and you want all
of them to be wrenchable, you can use only two functions to handle that).


A mini-mod showing WrenchFu integration is available on GitHub -- check it out
at <https://github.com/narc0tiq/WrenchFu-Demo>.


## License ##

The source of **WrenchFu** is Copyright 2015 Octav "narc" Sandulescu. It
is licensed under the [MIT license][mit], available in this package in the file
[LICENSE.md](LICENSE.md).

[mit]: http://opensource.org/licenses/mit-license.html


## Statistics ##

34 desyncs occurred during development of this mod. None were permanently injured.
