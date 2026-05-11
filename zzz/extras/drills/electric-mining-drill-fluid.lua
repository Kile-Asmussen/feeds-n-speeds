require 'prelude'

-- Copy electric mining drill (keeps the fluid input)
local base = data.raw['mining-drill']['electric-mining-drill']

local drill = table.clone(base)

drill.name = fns 'electric-mining-drill-fluid'
drill.minable.result = fns 'electric-mining-drill-fluid'

-- input_fluid_box is inherited from the clone

local drill_item = {
    type = 'item',
    name = fns 'electric-mining-drill-fluid',
    icons = {
        {
            icon = '__base__/graphics/icons/electric-mining-drill.png',
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
    order = 'a[items]-b[electric-mining-drill]-b[fluid]',
    place_result = fns 'electric-mining-drill-fluid',
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
    name = fns 'electric-mining-drill-fluid',
    enabled = false,
    energy_required = 1,
    ingredients = {
        { type = 'item', name = 'electric-mining-drill', amount = 1 },
        { type = 'item', name = 'pipe', amount = 3 },
    },
    results = {
        { type = 'item', name = fns 'electric-mining-drill-fluid', amount = 1 },
    },
}


return { drill, drill_item, drill_recipe }
