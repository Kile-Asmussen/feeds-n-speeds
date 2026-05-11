require 'prelude'

-- Copy burner mining drill and add fluid input on south side (opposite output)
local base = data.raw['mining-drill']['burner-mining-drill']

local drill = table.clone(base)

drill.name = fns 'burner-mining-drill-fluid'
drill.minable.result = fns 'burner-mining-drill-fluid'

-- Add fluid input on north side (same side as output chute, intentionally awkward)
-- Note: defines.direction is runtime-only; use numeric direction (0 = north)
-- Filter to steam only: usable for sulfur ore, not uranium (sulfuric acid)
drill.input_fluid_box = {
    volume = 50,
    filter = 'water',
    production_type = 'input',
    pipe_connections = {
        {
            direction = defines.direction.north,
            flow_direction = 'input',
            position = {0.5, -0.5},
        },
    },
    pipe_covers = pipecoverspictures(),
}

local drill_item = {
    type = 'item',
    name = fns 'burner-mining-drill-fluid',
    icons = {
        {
            icon = '__base__/graphics/icons/burner-mining-drill.png',
            icon_size = 64,
        },
        {
            icon = '__base__/graphics/icons/pipe.png',
            icon_size = 64,
            scale = 0.25,
            shift = {-8, -8},
        },
    },
    subgroup = 'extraction-machine',
    order = 'a[items]-a[burner-mining-drill]-b[fluid]',
    place_result = fns 'burner-mining-drill-fluid',
    stack_size = 50,
    drop_sound = {
        aggregation = { max_count = 1, remove = true },
        filename = '__base__/sound/item/drill-inventory-move.ogg',
        volume = 0.8,
    },
    inventory_move_sound = {
        aggregation = { max_count = 1, remove = true },
        filename = '__base__/sound/item/drill-inventory-move.ogg',
        volume = 0.8,
    },
    pick_sound = {
        aggregation = { max_count = 1, remove = true },
        filename = '__base__/sound/item/drill-inventory-pickup.ogg',
        volume = 0.8,
    },
}

drill.icons = table.clone(drill_item.icons)

local drill_recipe = {
    type = 'recipe',
    name = fns 'burner-mining-drill-fluid',
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = 'item', name = 'burner-mining-drill', amount = 1 },
        { type = 'item', name = 'pipe', amount = 1 },
    },
    results = {
        { type = 'item', name = fns 'burner-mining-drill-fluid', amount = 1 },
    },
}

return {
    drill,
    drill_item,
    drill_recipe
}
