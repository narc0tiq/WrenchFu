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


function WrenchFu.open_gui_for(player_index, entity)
    local reg = WrenchFu.handler_for(entity.name)
    
    global.open_guis[player_index] = global.open_guis[player_index] or {}
    
    global.open_guis[player_index][entity.name] = {
        ["position"] = entity.position,
        ["handler"] = reg,
    }

    remote.call(reg.mod_name, reg.show_method, player_index, entity)
end


function WrenchFu.close_gui_for(player_index,entity_name)
    if global.open_guis[player_index] == nil then return end
    if global.open_guis[player_index][entity_name] == nil then return end
    local gui_data = global.open_guis[player_index][entity_name]

    local reg = gui_data.handler
    if remote.call(reg.mod_name, reg.hide_method, player_index, entity_name, gui_data.position) then
        global.open_guis[player_index][entity_name] = nil
    end
end

function WrenchFu.close_gui_unconditionally(player_index,entity_name)
    if global.open_guis[player_index] == nil then return end
    if global.open_guis[player_index][entity_name] == nil then return end
    global.open_guis[player_index][entity_name] = nil
end

function WrenchFu.open_gui_at(place, player_index)
    if not global.open_guis then global.open_guis = {} end

    local player = game.get_player(player_index)
    if not player then return end

    local ents = player.surface.find_entities({place, place})
    for _,v in pairs(ents) do
        if WrenchFu.handler_for(v.name) ~= nil then
            local can=true
            for _,name in pairs(WrenchFu.handler_for(v.name).no_interlace_with) do
                can= WrenchFu.close_gui_for(player_index,name) and can
            end
            if can then 
                WrenchFu.open_gui_for(player_index, v)
            end
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
        if global.open_guis[player_index] then 
            for entity_name,gui_data in pairs(global.open_guis[player_index]) do
                if not gui_data.handler.max_distance then 
                    if util.distance(player.position, gui_data.position) > gui_data.handler.max_distance then
                        WrenchFu.close_gui_for(player_index,entity_name)
                    end
                end
            end
        end
    end
end
