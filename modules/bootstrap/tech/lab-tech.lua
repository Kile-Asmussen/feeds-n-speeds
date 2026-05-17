
local tools = require 'tools'

tools.remove_unlock('inserter')
tools.remove_unlock('lab')

data.raw.recipe['transport-belt'].unlocked_by = fns 'lab-tech'
data.raw.recipe['inserter'].unlocked_by = fns 'lab-tech'
data.raw.recipe['lab'].unlocked_by = fns 'lab-tech'

local tech = assoc{
    type = 'technology',
    name = fns 'lab-tech',
    order = 'a-a-z',
    icons = array{
        assoc{
            icon = '__base__/graphics/technology/research-speed.png',
            icon_size = 256
        },
    },
    prerequisites = array{ 'steam-power' },
    effects = array{
        -- assoc{
        --     type = 'unlock-recipe',
        --     recipe = 'lab',
        -- },
        -- assoc{
        --     type = 'unlock-recipe',
        --     recipe = 'transport-belt',
        -- },
        -- assoc{
        --     type = 'unlock-recipe',
        --     recipe = 'inserter',
        -- },
    },
    research_trigger = assoc{
        type = 'craft-item',
        item = 'steam-engine',
        amount = 2
    },
}

prototype(tech)