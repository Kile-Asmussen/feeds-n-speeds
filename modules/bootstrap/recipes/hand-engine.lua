--! data: hand-craftable engine unit recipe for early game
local fns = require 'fns'
local gadgets = fns.gadgets
local table = fns.table

table.merge(data.raw.recipe['engine-unit'], {
    ingredients = gadgets.throughputs{
        ['iron-gear-wheel'] = 2,
        ['steel-plate'] = 1,
        ['pipe'] = 2, },
    energy_required = 5,
})

local hand_engine = table.merge(table.deepcopy(data.raw.recipe['engine-unit']), {
    name = fns 'hand-engine-unit',
    localised_name = {'item-name.engine-unit'},
    category = fns 'hand-crafting',
    energy_required = 10,
    localised_description = {fns.locale_key('recipe-description', 'engine-unit')},
    icons = {
        gadgets.icon('icons/engine-unit.png'),
        gadgets.floating_icon("bottomleft",
            "__core__/graphics/icons/technology/constants/constant-equipment.png",
            {icon_size=128, shift = { -8, 8 }, scale = 0.2 }
        )
    },
    ingredients = table.append{{ type='item', name='coal', amount=1 }},
    auto_unlocked_by = 'steam-power',
})

table.merge(data.raw.recipe['electric-engine-unit'], {
    crafting_category = 'advanced_crafting',
    ingredients = gadgets.throughputs{
        ['copper-cable'] = 10,
        ['iron-gear-wheel'] = 2,
    },
    energy_required = 5,
})

local hand_electric_engine = table.merge(table.deepcopy(data.raw.recipe['electric-engine-unit']), {
    name = fns 'hand-electric-engine-unit',
    localised_name = {'item-name.electric-engine-unit'},
    category = fns 'hand-crafting',
    energy_required = 10,
    localised_description = {fns.locale_key('recipe-description', 'engine-unit')},
    icons = {
        gadgets.icon('icons/electric-engine-unit.png'),
        gadgets.floating_icon("bottomleft",
            "__core__/graphics/icons/technology/constants/constant-equipment.png",
            {icon_size=128, shift = { -8, 8 }, scale = 0.2 }
        )
    },
    ingredients = table.append{{ type='item', name='coal', amount=1 }},
    auto_unlocked_by = 'steam-power',
})

data:extend{ hand_engine, hand_electric_engine }

table.merge(data.raw.technology.engine, {
    __del = {'icon'},
    localised_description = {fns.locale_key('technology-description', 'engine')},
    unit = {
        ingredients = { { 'automation-science-pack', 1 } },
        time = 20,
        count = 10,
    },
    icons = {
        gadgets.icon('technology/automation-1.png', 256),
        gadgets.icon('technology/engine.png', 256),
    },
    prerequisites = { 'automation' },
})

table.merge(data.raw.technology['electric-engine'], {
    __del = {'icon'},
    localised_description = {fns.locale_key('technology-description', 'electric-engine')},
    unit = {
        ingredients = { { 'automation-science-pack', 1 } },
        time = 20,
        count = 10,
    },
    icons = {
        gadgets.icon('technology/automation-1.png', 256),
        gadgets.icon('technology/electric-engine.png', 256),
    },
    prerequisites = { 'automation' },
})

