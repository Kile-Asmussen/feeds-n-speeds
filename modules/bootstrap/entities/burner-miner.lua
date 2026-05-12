require 'prelude'

-- Copy burner mining drill and add fluid input on south side (opposite output)
local base = data.raw['mining-drill']['burner-mining-drill']

base.minable.mining_time = 1.0

local drill = table.clone(base)

drill.name = fns 'burner-mining-drill-fluid'
drill.minable.result = drill.name

drill.input_fluid_box = assoc{
    volume = 50,
    filter = 'water',
    production_type = 'input',
    pipe_connections = array{
        assoc{
            direction = defines.direction.north,
            flow_direction = 'input',
            position = {0.5, -0.5},
        },
    },
    pipe_covers = pipecoverspictures(),
}

drill.icon = nil
drill.icons = array{
    assoc{
        icon = '__base__/graphics/icons/burner-mining-drill.png',
        icon_size = 64,
    },
    assoc{
        icon = '__base__/graphics/icons/pipe.png',
        icon_size = 64,
        scale = 0.25,
        shift = {-8, -8},
    },
}

local drill_item = table.clone(data.raw.item['burner-mining-drill'])
drill_item.name = drill.name
drill_item.icons = table.clone(drill.icons)
drill_item.icon = nil
drill_item.order = 'a[items]-a[burner-mining-drill]-b[fluid]'
drill_item.place_result = drill.name

local drill_recipe = assoc{
    type = 'recipe',
    name = drill_item.name,
    enabled = false,
    energy_required = 2.0,
    ingredients = array{
        assoc{ type = 'item', name = 'burner-mining-drill', amount = 1 },
        assoc{ type = 'item', name = 'pipe', amount = 1 },
    },
    results = array{
        assoc{ type = 'item', name = drill_item.name, amount = 1 },
    },
}

prototype(
    drill,
    drill_item,
    drill_recipe
)
