--[[
WrenchFu's GUI parts: handles opening and closing of remote GUIs according to
the registry.

Tweakable:
- `WrenchFu.default_max_distance` determines the default maximum distance that a
    wrenchable can be from the player before its GUI closes automatically.  Set
    it to nil to disable that functionality (but be aware, this might leave you
    with an open GUI forever if there's no close button on it).

    Mods can override this by setting the option `proximity_distance` when
    registering.

]]

if not WrenchFu then WrenchFu = {} end
WrenchFu.default_max_distance = 6


function WrenchFu.open_gui_for(player, entity)
    if not player then return end

    local reg = WrenchFu.handler_for(entity.name)

    if reg.hide_method ~= nil then
        global.open_guis[player.index] = {
            ["entity_name"] = entity.name,
            ["position"] = entity.position,
            ["handler"] = reg,
        }
    end

    local player_reference = player.index
    if reg.wants_player then
        player_reference = player
    end

    if reg.wants_entity then
        remote.call(reg.mod_name, reg.show_method, player_reference, entity)
    else
        remote.call(reg.mod_name, reg.show_method, player_reference, entity.name, entity.position)
    end
end


function WrenchFu.close_gui_for(player_index)
    if global.open_guis[player_index] == nil then return end
    local gui_data = global.open_guis[player_index]

    local reg = gui_data.handler
    if reg.hide_method ~= nil then -- should never happen, but belt and suspenders approach
        remote.call(reg.mod_name, reg.hide_method, player_index, gui_data.entity_name, gui_data.position)
    end

    global.open_guis[player_index] = nil
end


function WrenchFu.open_gui_at(place, player)
    if not player then return end
    if not global.open_guis then global.open_guis = {} end

    local ents = player.surface.find_entities({place, place})
    for _,ent in pairs(ents) do
        if WrenchFu.handler_for(ent.name) ~= nil then
            WrenchFu.close_gui_for(player.index)
            WrenchFu.open_gui_for(player, ent)
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
        WrenchFu.open_gui_at(ent.position, player)
        ent.destroy()
    end
end


function WrenchFu.on_tick(event)
    if not global.open_guis then global.open_guis = {} end

    for player_index, player in pairs(game.players) do
        if global.open_guis[player_index] then
            local gui_data = global.open_guis[player_index]

            local proximity_distance = WrenchFu.default_max_distance
            if gui_data.handler.proximity_distance ~= nil then
                proximity_distance = gui_data.handler.proximity_distance
            end

            if proximity_distance ~= nil and util.distance(player.position, gui_data.position) > proximity_distance then
                WrenchFu.close_gui_for(player_index)
            end
        end
    end
end
