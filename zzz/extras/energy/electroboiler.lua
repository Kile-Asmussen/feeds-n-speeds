
local name = fns 'electroboiler'

-- Clone vanilla boiler and convert to electric energy source
local base = data.raw.boiler.boiler
local boiler = table.clone(base)

boiler.name = name
boiler.minable.result = name

-- Replace burner energy source with electric
boiler.energy_source = {
    type = 'electric',
    usage_priority = 'tertiary',
    emissions_per_minute = { pollution = 0 },
    drain = '18kW'
}

for _, picture in pairs(boiler.pictures) do
    picture.fire = nil
    picture.fire_glow = nil
end
 

-- Keep same energy consumption as vanilla boiler (1.8MW)
boiler.energy_consumption = '1.8MW'

-- Put in same fast-replace group as regular boiler
boiler.fast_replaceable_group = 'boiler'

local boiler_item = {
    type = 'item',
    name = name,
    icons = {
        {
            icon = '__base__/graphics/icons/boiler.png',
            icon_size = 64,
            scale = 0.5
        },
        {
            icon = '__base__/graphics/icons/signal/signal-lightning.png',
            floating = true,
            icon_size = 64,
            scale = 0.33,
            shift = { -6, 6 },
            tint = { r = 0, g = 1, b = 0 },
        }
    },
    subgroup = 'energy',
    order = 'b[steam-power]-a[electroboiler]',
    place_result = name,
    stack_size = 50,
}

boiler.icons = table.clone(boiler_item.icons)

local boiler_recipe = {
    type = 'recipe',
    name = name,
    enabled = false,
    ingredients = {
        { type = 'item', name = 'boiler', amount = 1 },
        { type = 'item', name = 'electronic-circuit', amount = 2 },
    },
    results = {
        { type = 'item', name = name, amount = 1 },
    },
}

return {
    boiler,
    boiler_item,
    boiler_recipe
}
