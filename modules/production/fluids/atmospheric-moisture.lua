--! data: joke recipe to boil water in a chemical plant

local fns = require 'fns'
local table = fns.table

local condense_air = {
    type='recipe',
    name=fns 'condense-atmospheric-water',
    category = 'chemistry',
    enabled=false,
    energy_required = -1,
    subgroup = '',
    auto_unlocked_by = 'fluid-handling',
    auto_recycle = false,
    subgroup = 'fluid-recipes',
    order = 'd[other-chemistry]-d[condensing]',
    show_amount_in_title = false,
    icons = {
        {
            icon = data.raw.fluid.water.icon,
        }
    },

    surface_conditions = {
        {
            property = 'pressure',
            min = 1000,
            max = 2000,
        }
    },
    
    emissions_multiplier = 0.5,
    energy_required = 5,

    ingredients = {},
    results = {
        { type='fluid', amount=10, name='water' }
    },
}

data:extend{
    condense_air
}