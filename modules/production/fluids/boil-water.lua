require 'prelude'

local boil_water = assoc{
    type='recipe',
    name=fns 'boil-water',
    category = 'chemistry',
    enabled=false,
    energy_required = math.nan,
    subgroup = '',
    allow_productivity = false,
    allow_consumption = false,
    allow_quality = false,
    allow_pollution = false,
    allowed_module_categories = {},
    subgroup = 'fluid-recipes',
    order = 'd[other-chemistry]-d[boiling]',
    show_amount_in_title = false,
    icons = array{
        assoc{
            icon = data.raw.fluid.steam.icon,
            float = true,
            scale = 0.7,
            shift = array{ 4, 0 }
        },
        assoc{
            icon = data.raw.fluid.water.icon,
            float = true,
            scale = 0.33,
            shift = array{ 4, -6 }
        },
        assoc{
            icon = data.raw['virtual-signal']['signal-thermometer-red'].icon,
            float = true,
            scale = 0.7,
            shift = array{ -6, 4 }
        },
    },

    emissions_multiplier = 0,
    hide_from_stats = true,

    ingredients = array{
        assoc{ type='fluid', amount=10, name='water' }
    },
    results = array{
        assoc{ type='fluid', amount=100, name='steam' }
    },
}

local plant = data.raw['assembling-machine']['chemical-plant']

local heat_cap = tools.joules_or_watts(steam.heat_capacity)
local power = tools.joules_or_watts(plant.energy_usage)
local boil_water = data.raw.recipe[fns 'boil-water']

local zero = steam.default_temperature
local boil = steam.gas_temperature
local diff = boil - zero
local energy_1 = heat_cap * diff
local energy = energy_1 * boil_water.results[1].amount
local proper_time = energy / power
local time = proper_time / plant.crafting_speed

boil_water.results[1].temperature = boil
boil_water.energy_required = math.ceil(time)

tools.remove_unlock('chemical-plant')

table.append(data.raw.technology['fluid-handling'].effects, {
    { type='unlock-recipe', recipe='chemical-plant' },
    { type='unlock-recipe', recipe=fns 'boil-water' },
})

prototype(boil_water)