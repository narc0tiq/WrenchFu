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

- your mod should depend on WrenchFu (optionally, or not, depending on whether
you think your mod could run without the wrenchability). This goes in your
info.json, and ensures your mod loads after WrenchFu:

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

function interface.hide_my_gui(player_index, entity_name, position)
    -- Do stuff here to hide your GUI; again, anything you like!
end

remote.add_interface("My-Mod-Interface", interface)
```

(I suppose technically you could have a single function, but then you'd have to
 remember if the GUI was supposed to be shown or hidden or not, and it would
 suck if your internal state got out of sync with what the player expected.)


- finally, and most importantly, your mod needs to register with WrenchFu. WrenchFu has the following interface:
```Lua
register=function(entity_name, handler_param)
    --[[this one registers the handler, which is going to be called when player uses Wrench onto the entity_name
        handler_param is the following table
        {
            mod_name = mod_name,--name of your interface (mandatory)
            show_method = show_method, 
            --[[name of function in your interface, which should be called whe entity_name is wrenched (mandatory)
            is function(player_index, entity), entity is game object here
            ]]
            hide_method = hide_method,
            --[[name of function to call when wrench is used on empty ground or player moved too far or a specific other entity if clicked with wrench 
            is function(player_index, entity_name, entity_position)
            must return true if it is allowed to close the gui
            ]]
            max_distance = max_distance,
            --max distance player can move away from entity before gui is closed, if nil - unlimited
            no_interlace_with = no_interlace_with 
            --[[names of other entities, which guis should be closed when gui for this entity is opened
            will always attempt to close gui for the same named entity.
            ]]
        }
    ]]
    close=function(player_index,entity_name)
    --[[should be called when your gui is closed not by WrenchFu facilities.
    cleans up the related data in this mod
    ]]
    ```
-Thus to register your entity, you need to put the following into `on_init` and `on_load` (or just into body of control.lua):

```Lua
    remote.call("WrenchFu", "register", "my-machine-name", {
        mod_name = "My-Mod-Interface", 
        show_method = "show_my_gui",
        hide_method = "hide_my_gui",
        max_distance = 30})
```

And that's all (from WrenchFu's point of view, at least).

You should note that only one handler can be registered for any given machine,
but that the same handler can be registered to multiple machines, if that's
useful to you (e.g., if you have several tiers of mining drill and you want all
of them to be wrenchable, but only need two functions to handle that).


A mini-mod showing WrenchFu integration is available on GitHub -- check it out
at <https://github.com/narc0tiq/WrenchFu-Demo>.


## License ##

The source of **WrenchFu** is Copyright 2015 Octav "narc" Sandulescu. It
is licensed under the [MIT license][mit], available in this package in the file
[LICENSE.md](LICENSE.md).

[mit]: http://opensource.org/licenses/mit-license.html


## Statistics ##

34 desyncs occurred during development of this mod. None were permanently injured.
