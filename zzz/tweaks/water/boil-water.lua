
return {{
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
    icons = {
        {
            icon = data.raw.fluid.steam.icon,
            float = true,
            scale = 0.7,
            shift = { 4, 0 }
        },
        {
            icon = data.raw.fluid.water.icon,
            float = true,
            scale = 0.33,
            shift = { 4, -6 }
        },
        {
            icon = data.raw['virtual-signal']['signal-thermometer-red'].icon,
            float = true,
            scale = 0.7,
            shift = { -6, 4 }
        },
    },

    emissions_multiplier = 0,
    hide_from_stats = true,

    ingredients = {
        { type='fluid', amount=10, name='water' }
    },
    results = {
        { type='fluid', amount=100, name='steam' }
    },
}}