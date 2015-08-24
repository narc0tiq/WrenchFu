local wrench_entity =
{
    type = "tree",
    name = "wrenchfu-wrench",
    icon = "__WrenchFu__/graphics/wrench.png",
    flags = {"placeable-off-grid"},
    max_health = 1,
    pictures = {{
            filename = "__WrenchFu__/graphics/nil.png",
            priority = "extra-high",
            width = 1,
            height = 1,
        }
    },
}


local wrench_item = {
    type = "item",
    name = "wrenchfu-wrench",
    icon = "__WrenchFu__/graphics/wrench.png",
    flags = {"goes-to-quickbar"},
    subgroup = "tool",
    order = "b[tools]-w[wrench]",
    stack_size = 10,
    place_result = "wrenchfu-wrench",
}

data:extend({wrench_entity, wrench_item})
