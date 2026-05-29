
local fns = require 'fns'

fns.table.merge(data.raw.technology['cliff-explosives'], {
    unit = {
        time = 30,
        count = 500,
        ingredients = {
            { 'automation-science-pack', 1 },
            { 'logistic-science-pack', 1 },
            { 'chemical-science-pack', 1 },
            { 'military-science-pack', 1 },
            { 'utility-science-pack', 1 },
        },
    },
    prerequisites = { 'military-4' },
    
})

data.raw.recipe['cliff-explosives'].ingredients = fns.gadgets.throughputs{
    ['explosives'] = 20,
    ['barrel'] = 1,
    ['cluster-grenade'] = 1,
}
