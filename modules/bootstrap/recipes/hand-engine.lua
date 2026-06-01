--! data: hand-craftable engine unit recipe for early game
local fns = require 'fns'
local table = fns.table

local hand_engine = table.merge(table.deepcopy(data.raw.recipe['engine-unit']), {
    name = fns 'hand-engine-unit',
    localised_name = {'item-name.engine-unit'},
    category = fns 'hand-crafting',
    energy_required = 10,
    ingredients = fns.gadgets.throughputs{
        ['steel-plate'] = 1,
        ['iron-gear-wheel'] = 1,
        ['copper-plate'] = 2,
        ['pipe'] = 2,
    },
    auto_unlocked_by = 'steam-power',
})

data:extend{ hand_engine }

table.merge(data.raw.technology.engine, {
    localised_description = {fns.locale_key('technology-description', 'engine')},
    unit = {
        ingredients = { { 'automation-science-pack', 1 } },
        time = 10,
        count = 10,
    },
    prerequisites = { 'automation' },
})

