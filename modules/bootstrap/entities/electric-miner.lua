require 'prelude'

local base = data.raw['mining-drill']['electric-mining-drill']
base.minable.mining_time = 1.5

local drill = table.clone(data.raw['mining-drill']['electric-mining-drill'])

drill.name = fns 'electric-mining-drill-fluid'
drill.minable.result = fns 'electric-mining-drill-fluid'
drill.icon = nil

drill.icons = array{
    assoc{
        icon = '__base__/graphics/icons/electric-mining-drill.png',
        icon_size = 64,
    },
    assoc{
        icon = '__base__/graphics/icons/pipe.png',
        icon_size = 64,
        scale = 0.25,
        shift = {-8, -8},
    },
}

-- input_fluid_box is inherited from the clone

local drill_item = table.clone(data.raw.item['electric-mining-drill'])
drill_item.name = drill.name
drill_item.place_result = drill.name

drill_item.icons = table.clone(drill.icons)

local drill_recipe = assoc{
    type = 'recipe',
    name = drill.name,
    enabled = false,
    energy_required = 2.0,
    ingredients = array{
        assoc{ type = 'item', name = 'electric-mining-drill', amount = 1 },
        assoc{ type = 'item', name = 'pipe', amount = 3 },
    },
    results = array{
        assoc{ type = 'item', name = drill.name, amount = 1 },
    },
}


prototype( drill, drill_item, drill_recipe )

data.raw['mining-drill']['electric-mining-drill'].input_fluid_box = nil
