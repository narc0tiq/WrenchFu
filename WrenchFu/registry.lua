--[[
WrenchFu's registry: keeps the wrenchable handler registry.

]]
if not WrenchFu then WrenchFu = {} end
local handler_registry = {}


interface = {}
function interface.register_gui(entity_name, mod_name, show_method, hide_method, options)
    local handler = handler_registry[entity_name]
    if handler ~= nil and handler.mod_name ~= mod_name then
        WrenchFu.notify_all({"warn_stealing_registry", entity_name, handler.mod_name, mod_name})
    end

    local new_handler = {
        mod_name = mod_name,
        show_method = show_method,
        hide_method = hide_method,
    }

    if options ~= nil then
        for k,v in pairs(options) do
            new_handler[k] = v
        end
    end

    handler_registry[entity_name] = new_handler
end
-- alias for the common case (already in use from v<0.2)
interface.register = interface.register_gui


function interface.register_wrenched(mod_name, wrenched_method, options)
    -- TODO: do stuff
end


function interface.register_leaves_proximity(mod_name, proximity_method, options)
    if options.player_index ~= nil then options.player = game.get_player(options.player_index) end

    -- TODO: if no player, complain
    -- TODO: if no entity, complain
    -- TODO: otherwise, just do stuff
end


remote.add_interface("WrenchFu", interface)


function WrenchFu.handler_for(entity_name)
    return handler_registry[entity_name]
end
