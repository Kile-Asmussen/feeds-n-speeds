require 'prelude'

local chests = namespace 'extras.chests'

chests.enabled = true

function chests.data()
    if not chests.enabled then return end

    data:extend{
        require('extras.chests.big-steel-chest-building'),
        require('extras.chests.big-steel-chest-item'),
        require('extras.chests.big-steel-chest-recipe'),
        require('extras.chests.big-steel-chest-remnants'),
        require('extras.chests.big-steel-chest-explosion'),
        require('extras.chests.smart-big-steel-chest-building'),
        require('extras.chests.smart-big-steel-chest-item'),
        require('extras.chests.smart-big-steel-chest-recipe'),
        require('extras.chests.big-steel-hopper-building'),
        require('extras.chests.big-steel-hopper-item'),
        require('extras.chests.big-steel-hopper-recipe'),
    }

    local tech =  data.raw.technology

    table.insert(tech['steel-processing'].effects, {
        type = 'unlock-recipe',
        recipe = fns 'big-steel-chest',
    })

    table.insert(tech['automation-2'].effects, {
        type = 'unlock-recipe',
        recipe = fns 'smart-big-steel-chest',
    })
    
    table.insert(tech['automation-2'].effects, {
        type = 'unlock-recipe',
        recipe = fns 'big-steel-hopper',
    })
end

function chests.control()
    
end

return chests:__seal()