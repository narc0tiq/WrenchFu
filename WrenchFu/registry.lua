--[[
WrenchFu's registry: keeps the wrenchable handler registry.

]]
if not WrenchFu then WrenchFu = {} end
local handler_registry = {}

interface = {}
function interface.register(entity_name, mod_name, show_method, hide_method, max_distance,no_interlace_with)
    local handler = handler_registry[entity_name]
    if handler ~= nil and handler.mod_name ~= mod_name then
        WrenchFu.notify_all({"warn_stealing_registry", entity_name, handler.mod_name, mod_name})
    end
    
    no_interlace_with = no_interlace_with or {}
    no_interlace_with.[entity_name]=true
    
    handler_registry[entity_name] = {
        mod_name = mod_name,
        show_method = show_method,
        hide_method = hide_method,
        max_distance = max_distance,
        no_interlace_with = no_interlace_with 
    }
    if max_distance and  ( ( not WrenchFu.max_distance) or WrenchFu.max_distance < max_distance ) then
        WrenchFu.max_distance = max_distance
    end
end
remote.add_interface("WrenchFu", interface)


function WrenchFu.handler_for(entity_name)
    return handler_registry[entity_name]
end
