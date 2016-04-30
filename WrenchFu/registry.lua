--[[
WrenchFu's registry: keeps the wrenchable handler registry.

]]
if not WrenchFu then WrenchFu = {} end
local handler_registry = {}

interface = {}
function interface.register(entity_name, handler_params)
    
    local handler = handler_registry[entity_name]
    if handler ~= nil and handler.mod_name ~= handler_params.mod_name then
        WrenchFu.notify_all({"warn_stealing_registry", entity_name, handler.mod_name, handler_params.mod_name})
    end
    handler = handler_params
    if not handler.mod_name or not remote.interfaces[handler.mod_name] then
        WrenchFu.notify_all({"error_no_interface name", entity_name}) end
    if not handler.show_method or not remote.interfaces[handler.mod_name][handler.show_method] then
        WrenchFu.notify_all({"error_no_function_to_call", entity_name, handler_params.mod_name}) 
    end
    
    handler.no_interlace_with = handler.no_interlace_with or {}
    handler.no_interlace_with[entity_name]=true
    
    handler_registry[entity_name] = handler
    
    if max_distance and  ( ( not WrenchFu.max_distance) or WrenchFu.max_distance < max_distance ) then
        WrenchFu.max_distance = max_distance
    end
end
function interface.close(player_index,entity_name)
    return WrenchFu.close_gui_unconditionally(player_index,entity_name)
end
remote.add_interface("WrenchFu", interface)


function WrenchFu.handler_for(entity_name)
    return handler_registry[entity_name]
end
