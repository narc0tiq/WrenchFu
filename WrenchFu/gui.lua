--[[
WrenchFu's GUI parts: handles opening and closing of remote GUIs according to
the registry.

Tweakable:
- `WrenchFu.max_distance` determines the maximum distance that a wrenchable can
    be from the player before its GUI closes automatically.  Set it to nil to
    disable that functionality (but be aware, this might leave you with an open GUI
    forever if there's no close button on it).

]]

if not WrenchFu then WrenchFu = {} end
WrenchFu.max_distance = 6


function WrenchFu.open_gui_for(player_index, entity_name, position, surface_name)
    local reg = WrenchFu.handler_for(entity_name)

    global.open_guis[player_index] = {
        ["entity_name"] = entity_name,
        ["position"] = position,
        ["surface_name"] = surface_name,
        ["handler"] = reg,
    }

    remote.call(reg.mod_name, reg.show_method, player_index, entity_name, position, surface_name)
end


function WrenchFu.close_gui_for(player_index)
    if global.open_guis[player_index] == nil then return end
    local gui_data = global.open_guis[player_index]

    local reg = gui_data.handler
    remote.call(reg.mod_name, reg.hide_method, player_index, gui_data.entity_name, gui_data.position, gui_data.surface_name)

    global.open_guis[player_index] = nil
end


function WrenchFu.open_gui_at(place, player_index)
    if not global.open_guis then global.open_guis = {} end

    local player = game.get_player(player_index)
    if not player then return end

    local ents = player.surface.find_entities({place, place})
    for _,v in pairs(ents) do
        if WrenchFu.handler_for(v.name) ~= nil then
            WrenchFu.close_gui_for(player_index)
            WrenchFu.open_gui_for(player_index, v.name, v.position, v.surface.name)
        end
    end
end


function WrenchFu.on_built_entity(event)
    local ent = event.created_entity

    local player = game.get_player(event.player_index)
    if ent.name == "wrenchfu-wrench" then
        if not player.cursor_stack.valid_for_read then
            player.cursor_stack.set_stack{ name = "wrenchfu-wrench", count = 1 }
        elseif player.cursor_stack.name == "wrenchfu-wrench" then
            player.cursor_stack.count = player.cursor_stack.count + 1
        end
        WrenchFu.open_gui_at(ent.position, event.player_index)
        ent.destroy()
    end
end


function WrenchFu.on_tick(event)
    if WrenchFu.max_distance == nil then return end
    if not global.open_guis then global.open_guis = {} end

    for player_index, player in pairs(game.players) do
        if global.open_guis[player_index] == nil then return end
        local gui_data = global.open_guis[player_index]

        if util.distance(player.position, gui_data.position) > WrenchFu.max_distance then
            WrenchFu.close_gui_for(player_index)
        end
    end
end
