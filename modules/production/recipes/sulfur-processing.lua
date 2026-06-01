--! data: changes to sulfur-related recipes and new sulfur-producing oil processing variants
local fns = require 'fns'

local puts = fns.gadgets.throughputs
local icons = fns.gadgets.icons
local merge = fns.table.merge

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
        icons = icons{
            type = 'recipe',
            { '__base__/graphics/icons/fluid/basic-oil-processing.png' },
            { '__base__/graphics/icons/sulfur.png', size='small', dir = 'tl', },
        },
        ingredients = puts{ ['crude-oil'] = 100 },
        results = puts{ ['petroleum-gas'] = 55, ['sulfur'] = 1 },
        main_product = '',
        subgroup = 'fluid-recipes',
        order = 'a[oil-processing]-a[basic-oil-processing]-b',
        allow_productivity = true,
        allow_quality = true,
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
        icons = icons{
            type = 'recipe',
            '__base__/graphics/icons/fluid/advanced-oil-processing.png',
            { '__base__/graphics/icons/sulfur.png', size='small', dir = 'tl' },
        },
        ingredients = puts{ ['steam'] = 50, ['crude-oil'] = 100 },
        results = puts{ ['heavy-oil'] = 30, ['light-oil'] = 55, ['petroleum-gas'] = 70, ['sulfur'] = 2, },
        main_product = '',
        subgroup = 'fluid-recipes',
        order = 'a[oil-processing]-b[advanced-oil-processing]-b',
        allow_productivity = true,
        allow_quality = true,
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
        icons = icons{
            type = 'recipe', 
            '__base__/graphics/icons/fluid/heavy-oil-cracking.png',
            { '__base__/graphics/icons/sulfur.png', size='small', dir='tl', },
        },
        ingredients = puts{ ['steam'] = 30, ['heavy-oil'] = 50 },
        results = puts{ ['light-oil'] = 40, ['sulfur'] = 1 },
        main_product = '',
        subgroup = 'fluid-recipes',
        order = 'b[fluid-chemistry]-a[heavy-oil-cracking]-b',
        allow_productivity = true,
        allow_quality = true,
    },
}

local sulfuric_acid = data.raw.recipe['sulfuric-acid']

merge(data.raw.recipe, {
    __rec = true, -- recurse one level
    ['sulfuric-acid'] = {
        main_product = 'sulfuric-acid',
        ingredients = puts{ ['steel-plate'] = 1, ['sulfur'] = 5, ['water'] = 100 },
        results = puts{ ['steel-plate'] = { 1, 0.8 }, ['sulfuric-acid'] = 50 },
    },
    ['sulfur'] = {
        main_product = 'sulfur',
        emissions_multiplier = 1.5,
        ingredients = puts{ ['coal'] = 5, ['petroleum-gas'] = 30, ['water'] = 50 },
        results = puts{ ['coal'] = { 4, 5 }, ['sulfur'] = 1 }
    },
    ['coal-liquefaction'] = {
        ingredients = puts{
            ['coal'] = 10,
            ['heavy-oil'] = 25,
            ['steam'] = 50
        },
        results = puts{
            ['sulfur'] = { 1, 0.2 }, 
            ['heavy-oil'] = 90,
            ['light-oil'] = 20,
            ['petroleum-gas'] = 10,
        },
    },
    ['explosives'] = {
        ingredients = puts{
            ['solid-fuel'] = 2,
            ['sulfuric-acid'] = 20,
        }
    },
})
