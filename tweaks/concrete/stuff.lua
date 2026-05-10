require 'prelude'

-- Simple concrete: same inputs as vanilla, lower output (5 vs 10)
-- Assembly machine craftable (crafting-with-fluid)
-- No refined concrete equivalent in this recipe chain

return {
    { type = 'collision-layer', name = fns('basic_pavement', '_') },
    { type = 'collision-layer', name = fns('sturdy_pavement', '_') },
    { type = 'collision-layer', name = fns('sturdy_pavement_hazard', '_') },
    { type = 'collision-layer', name = fns('foundation_pavement', '_') },
    { type = 'collision-layer', name = fns('foundation_pavement_hazard', '_') },
    {
        type = 'recipe',
        name = fns 'simple-concrete',
        category = 'advanced-crafting',
        -- localised_description = {""},
        enabled = false,
        hidden = enabled('extras.barreling'),
        energy_required = 10,
        allow_speed = false,
        allow_pollution = false,
        allow_productivity = false,
        allow_quality = false,
        allow_consumption = false,
        auto_recycle = false,
        ingredients = {
            { type = 'item', name = 'iron-ore', amount = 1 },
            { type = 'item', name = 'stone-brick', amount = 2 },
            { type = 'item', name = 'water-barrel', amount = 1 },
        },
        icons = {
            {
                icon = data.raw.item['concrete'].icon,
                icon_size = 64,
            },
            {
                icon = data.raw.item['barrel'].icon,
                icon_size = 64,
                scale = 0.25,
                shift = {-8, -8},
            },
        },
        main_product = 'concrete',
        results = {
            { type = 'item', name = 'concrete', amount = 1 },
            { type = 'item', name = 'barrel', amount = 1 },
        },
        order = 'b[concrete]-a[simple]',
    }
}