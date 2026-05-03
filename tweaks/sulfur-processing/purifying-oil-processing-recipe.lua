require 'prelude'

-- Purifying variant of basic oil processing
-- Slightly slower but higher yield, also extracts sulfur

return {
    type = 'recipe',
    name = fns 'purifying-oil-processing',
    localised_name = {"", {"recipe-name.basic-oil-processing"}},
    localised_description = {"", {fns_locale_key("recipe-description", "clean-oil")}},
    category = 'oil-processing',
    enabled = false,
    energy_required = 6,  -- slightly slower than basic (5)
    emissions_multiplier = 0.8,
    icons = {
        { icon = '__base__/graphics/icons/fluid/basic-oil-processing.png', icon_size = 64 },
        {
            icon = '__base__/graphics/icons/sulfur.png',
            icon_size = 64,
            scale = 0.25,
            shift = { -8, -8 },
        },
    },
    ingredients = {
        { type = 'fluid', name = 'crude-oil', amount = 100 },
    },
    results = {
        { type = 'fluid', name = 'petroleum-gas', amount = 55 },  -- slightly higher than basic (45)
        { type = 'item', name = 'sulfur', amount = 1 },
    },
    main_product = '',
    subgroup = 'fluid-recipes',
    order = 'a[oil-processing]-a[basic-oil-processing]-b',
    allow_productivity = true,
    allow_quality = false,
}
