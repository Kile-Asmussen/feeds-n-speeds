--! data: boiler variant using electric power

local fns = require 'fns'
local table = fns.table
local merge = fns.table.merge
local name = fns 'electroboiler'

local boiler = merge(table.deepcopy(data.raw.boiler.boiler), {
    name = name,
    minable = { __merge = true, result = name },
    energy_source = {
        type = 'electric',
        usage_priority = 'tertiary',
        emissions_per_minute = { pollution = 0 },
        drain = '18kW'
    },
    auto_require_pavement = 'stone-path',
    energy_consumption = '1.8MW'
})

for _, picture in pairs(boiler.pictures) do
    picture.fire = nil
    picture.fire_glow = nil
end

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
            icon = '__core__/graphics/icons/alerts/electricity-icon-unplugged.png',
            floating = true,
            icon_size = 64,
            scale = 0.25,
            shift = { -8, 8 },
            tint = { r = 0, g = 1, b = 0 },
        }
    },
    subgroup = 'energy',
    order = 'b[steam-power]-a[electroboiler]',
    place_result = name,
    stack_size = 10,
}

boiler.icons = table.deepcopy(boiler_item.icons)

local boiler_recipe = {
    type = 'recipe',
    name = name,
    enabled = false,
    auto_unlocked_by = 'advanced-oil-processing',
    ingredients = {
        { type = 'item', name = 'boiler', amount = 1 },
        { type = 'item', name = 'copper-cable', amount = 10 },
    },
    results = {
        { type = 'item', name = name, amount = 1 },
    },
}

data:extend{
    boiler,
    boiler_item,
    boiler_recipe
}
