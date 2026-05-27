
data.raw.recipe['burner-mining-drill'].auto_unlocked_by = 'steam-power'

-- Copy burner mining burner_drill and add fluid input on south side (opposite output)
local burner_drill = table.clone(data.raw['mining-drill']['burner-mining-drill'])

local name = fns 'burner-mining-drill-fluid'

table.merge(burner_drill, {
    name = fns 'burner-mining-drill-fluid',
    minable = table.assign{'result', val = name},
    input_fluid_box = {
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
    },
    icon = functions.null,
    icons = {
        {
            icon = '__base__/graphics/icons/burner-mining-drill.png',
            icon_size = 64,
        },
        {
            icon = '__base__/graphics/icons/water.png',
            icon_size = 64,
            scale = 0.25,
            shift = {-8, -8},
        },
    },
})

local burner_drill_item = table.clone(data.raw.item['burner-mining-drill'])

table.merge(burner_drill_item, {
    name = name,
    place_result = name,
    icons = table.clone(burner_drill.icons)
    icon = functions.null,
    order = 'a[items]-a[burner-mining-drill]-b[fluid]',
})


local burner_drill_recipe = {
    type = 'recipe',
    name = burner_drill_item.name,
    auto_unlocked_by = fns 'wet-drilling',
    enabled = false,
    energy_required = 2.0,
    ingredients = {
        { type = 'item', name = 'burner-mining-drill', amount = 1 },
        { type = 'item', name = 'pipe', amount = 1 },
    },
    results = {
        { type = 'item', name = burner_drill_item.name, amount = 1 },
    },
}

data:extend{
    burner_drill,
    burner_drill_item,
    burner_drill_recipe
}
