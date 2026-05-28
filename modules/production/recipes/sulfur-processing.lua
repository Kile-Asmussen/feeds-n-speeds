
local fns = require 'fns'

data:extend{
    {
        type = 'recipe',
        name = fns 'purifying-oil-processing',
        localised_name = {"", {"recipe-name.basic-oil-processing"}},
        localised_description = {"", {fns.locale_key("recipe-description", "clean-oil")}},
        category = 'oil-processing',
        enabled = false,
        auto_unlocked_by = 'sulfur-processing',
        energy_required = 6,
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
            { type = 'fluid', name = 'petroleum-gas', amount = 55 },
            { type = 'item', name = 'sulfur', amount = 1 },
        },
        main_product = '',
        subgroup = 'fluid-recipes',
        order = 'a[oil-processing]-a[basic-oil-processing]-b',
        allow_productivity = true,
        allow_quality = false,
    },
    {
        type = 'recipe',
        name = fns 'purifying-advanced-oil-processing',
        localised_name = {"", {"recipe-name.advanced-oil-processing"}},
        localised_description = {"", {fns.locale_key("recipe-description", "clean-oil")}},
        category = 'oil-processing',
        enabled = false,
        auto_unlocked_by = 'advanced-oil-processing',
        energy_required = 6,
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
            { type = 'fluid', name = 'heavy-oil', amount = 30 },
            { type = 'fluid', name = 'light-oil', amount = 55 },
            { type = 'fluid', name = 'petroleum-gas', amount = 70 },
            { type = 'item', name = 'sulfur', amount = 2 },
        },
        main_product = '',
        subgroup = 'fluid-recipes',
        order = 'a[oil-processing]-b[advanced-oil-processing]-b',
        allow_productivity = true,
        allow_quality = false,
    },
    {
        type = 'recipe',
        name = fns 'purifying-heavy-oil-cracking',
        localised_name = {"", {"recipe-name.heavy-oil-cracking"}},
        localised_description = {"", {fns.locale_key("recipe-description", "clean-oil")}},
        category = 'organic-or-chemistry',
        enabled = false,
        auto_unlocked_by = 'advanced-oil-processing',
        energy_required = 2.5,
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
            { type = 'fluid', name = 'light-oil', amount = 40 },
            { type = 'item', name = 'sulfur', amount = 1 },
        },
        main_product = '',
        subgroup = 'fluid-recipes',
        order = 'b[fluid-chemistry]-a[heavy-oil-cracking]-b',
        allow_productivity = true,
        allow_quality = false,
    },
}

local sulfuric_acid = data.raw.recipe['sulfuric-acid']

table.find_matching(sulfuric_acid.ingredients,
    { name = 'iron-plate' }
).name = 'steel-plate'

table.insert(sulfuric_acid.results, {
    type = 'item',
    name = 'steel-plate',
    amount = 1,
    probability = 0.8,
})

sulfuric_acid.main_product = 'sulfuric-acid'

local sulfur = data.raw.recipe['sulfur']

sulfur.ingredients = {
    { type = 'fluid', name = 'petroleum-gas', amount = 30 },
    { type = 'item', name = 'coal', amount = 5 },
    { type = 'fluid', name = 'water', amount = 50 },
}

sulfur.results = {
    { type = 'item', name = 'coal', amount = 4 },
    { type = 'item', name = 'sulfur', amount = 1 },
}

sulfur.emissions_multiplier = 1.5
sulfur.main_product = 'sulfur'

table.insert(data.raw.recipe['coal-liquefaction'].results, {
    type = 'item',
    name = 'sulfur',
    amount = 1,
    probability = 0.2,
})

data.raw.recipe['explosives'].ingredients = {
    { type = 'item', name = 'solid-fuel', amount = 2 },
    { type = 'fluid', name = 'sulfuric-acid', amount = 20 },
}
