interface = {}

function interface.register(ent_name, mod_name, show_method, hide_method)
    if global.handler_registry == nil then global.handler_registry = {} end

    global.handler_registry[ent_name] = {
        mod_name = mod_name,
        show_method = show_method,
        hide_method = hide_method,
    }
end

remote.add_interface("WrenchFu", interface)
