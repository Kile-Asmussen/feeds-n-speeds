require 'prelude'

return {{
    type='recipe',
    name=fns 'boil-water',
    category = 'chemistry',
    enabled=false,
    energy_required = math.nan,
    allow_productivity = false,
    allow_consumption = false,
    allow_quality = false,
    allow_pollution = false,
    allowed_module_categories = {},
    subgroup = '',
    icons = {
        {
            icon = data.raw.fluid.water.steam,
            float = true
            scale = 0.5,
            shift = { 0, 4 }
        },
        {
            icon = data.raw.fluid.water.icon,
            float = true
            scale = 0.33,
            shift = { 0, -6 }
        },
        {
            icon = data.raw['virtual-signal']['signal-thermometer-red'],
            float = true
            scale = 0.33,
            shift = { -6, 6 }
        },
    }

    emissions_multiplier = 0,
    hide_from_stats = true,

    ingredients = {
        { type='fluid', amount=10, name='water' }
    },
    results = {
        { type='fluid', amount=100, name='steam' }
    },
}}