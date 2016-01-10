require "defines"
require "util"

if not WrenchFu then WrenchFu = {} end

require "WrenchFu.core"
require "WrenchFu.gui"
require "WrenchFu.registry"


local function on_built_entity(event)
    local status, err = pcall(WrenchFu.on_built_entity, event)
    if err then WrenchFu.notify_all({"error_event", "on_built_entity", err}) end
end


local function on_tick(event)
    local status, err = pcall(WrenchFu.on_tick, event)
    if err then WrenchFu.notify_all({"error_event", "on_tick", err}) end
end


script.on_event(defines.events.on_built_entity, on_built_entity)
script.on_event(defines.events.on_tick, on_tick)
