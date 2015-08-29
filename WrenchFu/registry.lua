--[[
WrenchFu's registry: keeps the wrenchable handler registry.

]]
if not WrenchFu then WrenchFu = {} end
local handler_registry = {}


interface = {}
function interface.register(entity_name, mod_name, show_method, hide_method)
    local handler = handler_registry[entity_name]
    if handler ~= nil and handler.mod_name ~= mod_name then
        WrenchFu.notify_all({"warn_stealing_registry", entity_name, handler.mod_name, mod_name})
    end

    handler_registry[entity_name] = {
        mod_name = mod_name,
        show_method = show_method,
        hide_method = hide_method,
    }
end
remote.add_interface("WrenchFu", interface)


function WrenchFu.handler_for(entity_name)
    return handler_registry[entity_name]
end
