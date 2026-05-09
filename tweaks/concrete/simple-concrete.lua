require 'prelude'

-- Simple concrete: same inputs as vanilla, lower output (5 vs 10)
-- Assembly machine craftable (crafting-with-fluid)
-- No refined concrete equivalent in this recipe chain

return {{
    type = 'recipe',
    name = fns 'simple-concrete',
    category = 'crafting',
    -- localised_description = {""},
    enabled = false,
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
            icon = '__base__/graphics/icons/concrete.png',
            icon_size = 64,
        },
        {
            icon = '__base__/graphics/icons/barrel.png',
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
}}