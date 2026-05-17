
-- Purifying variant of advanced oil processing
-- Slightly slower but higher yield, also extracts sulfur

return {
    type = 'recipe',
    name = fns 'purifying-advanced-oil-processing',
    localised_name = {"", {"recipe-name.advanced-oil-processing"}},
    localised_description = {"", {fns_locale_key("recipe-description", "clean-oil")}},
    category = 'oil-processing',
    enabled = false,
    energy_required = 6,  -- slightly slower than advanced (5)
    emissions_multiplier = 0.8,
    icons = {
        { icon = '__base__/graphics/icons/fluid/advanced-oil-processing.png', icon_size = 64 },
        {
            icon = '__base__/graphics/icons/sulfur.png',
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    ingredients = {
        { type = 'fluid', name = 'water', amount = 50 },
        { type = 'fluid', name = 'crude-oil', amount = 100 },
    },
    results = {
        { type = 'fluid', name = 'heavy-oil', amount = 30 },      -- +5 from 25
        { type = 'fluid', name = 'light-oil', amount = 55 },      -- +10 from 45
        { type = 'fluid', name = 'petroleum-gas', amount = 70 },  -- +15 from 55
        { type = 'item', name = 'sulfur', amount = 2 },
    },
    main_product = '',
    subgroup = 'fluid-recipes',
    order = 'a[oil-processing]-b[advanced-oil-processing]-b',
    allow_productivity = true,
    allow_quality = false,
}
