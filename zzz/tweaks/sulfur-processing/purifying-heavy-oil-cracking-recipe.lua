
-- Purifying variant of heavy oil cracking
-- Slightly slower but higher yield, also extracts sulfur

return {
    type = 'recipe',
    name = fns 'purifying-heavy-oil-cracking',
    localised_name = {"", {"recipe-name.heavy-oil-cracking"}},
    localised_description = {"", {fns_locale_key("recipe-description", "clean-oil")}},
    category = 'organic-or-chemistry',
    enabled = false,
    energy_required = 2.5,  -- slightly slower than vanilla (2)
    emissions_multiplier = 0.8,
    icons = {
        { icon = '__base__/graphics/icons/fluid/heavy-oil-cracking.png', icon_size = 64 },
        {
            icon = '__base__/graphics/icons/sulfur.png',
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    ingredients = {
        { type = 'fluid', name = 'water', amount = 30 },
        { type = 'fluid', name = 'heavy-oil', amount = 50 },
    },
    results = {
        { type = 'fluid', name = 'light-oil', amount = 40 },  -- +10 from 30
        { type = 'item', name = 'sulfur', amount = 1 },
    },
    main_product = '',
    subgroup = 'fluid-recipes',
    order = 'b[fluid-chemistry]-a[heavy-oil-cracking]-b',
    allow_productivity = true,
    allow_quality = false,
}
