require "defines"
require "remote"


local function open_gui_for(player_index, entity_name, position)
    local reg = global.handler_registry[entity_name]

    global.open_guis[player_index] = {
        entity_name = entity_name,
        position = position,
        mod_name = reg.mod_name,
    }

    remote.call(reg.mod_name, reg.show_method, player_index, entity_name, position)
end


local function close_open_gui(player_index)
    if global.open_guis[player_index] == nil then return end
    local gui_data = global.open_guis[player_index]

    local reg = global.handler_registry[gui_data.entity_name]
    remote.call(reg.mod_name, reg.hide_method, player_index, gui_data.entity_name, gui_data.position)

    global.open_guis[player_index] = nil
end


local function on_built_entity(event)
    if not global.open_guis then global.open_guis = {} end

    local player = game.get_player(event.player_index)
    local ent = event.created_entity
    local place = ent.position

    if ent.name == "wrenchfu-wrench" then
        ent.destroy()
        if not global.handler_registry then player.print("Nil registry!") return end

        local ents = player.surface.find_entities({place, place})
        for _,v in pairs(ents) do
            if global.handler_registry[v.name] ~= nil then
                close_open_gui(event.player_index)
                open_gui_for(event.player_index, v.name, v.position)
            end
        end
    end
end


local function on_put_item(event)
    local player = game.get_player(event.player_index)
    if player.cursor_stack.name == "wrenchfu-wrench" then
        player.cursor_stack.count = player.cursor_stack.count + 1
    end
end


game.on_event(defines.events.on_built_entity, on_built_entity)
game.on_event(defines.events.on_put_item, on_put_item)
