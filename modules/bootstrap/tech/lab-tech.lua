
local tools = require 'gadgets'

tools.remove_unlock('inserter')
tools.remove_unlock('lab')

data.raw.recipe['transport-belt'].auto_unlocked_by = fns 'lab-tech'
data.raw.recipe['inserter'].auto_unlocked_by = fns 'lab-tech'
data.raw.recipe['lab'].auto_unlocked_by = fns 'lab-tech'

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
    research_trigger = assoc{
        type = 'craft-item',
        item = 'steam-engine',
        amount = 1
    },
}

data:extend{tech}