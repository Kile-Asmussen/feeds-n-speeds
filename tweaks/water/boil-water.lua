require 'prelude'

return {{
    type='recipe',
    name=fns 'boil-water',
    enabled=false,
    energy_required = math.nan,
    allow_productivity = false,
    allow_consumption = false,
    allow_quality = false,
    allow_pollution = false,
    allowed_module_categories = {},

    emissions_multiplier = 0,
    hide_from_stats = true,

    ingredients = {
        { type='fluid', amount=10, name='water' }
    },
    results = {
        { type='fluid', amount=100, name='steam' }
    },
}}