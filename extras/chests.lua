require 'prelude'

local chests = namespace 'extras.chests'

chests.toggle = 'feeds-n-speeds-extras-chests-enable'
chests.enabled = true

function chests.data()
    if not chests.enabled then return end

    table.insert(data.raw.technology['steel-processing'].effects, {
        type = 'unlock-recipe',
        recipe = 'big-steel-chest',
    })

    data:extend{
        require('extras.chests.big-steel-chest-building'),
        require('extras.chests.big-steel-chest-item'),
        require('extras.chests.big-steel-chest-explosion'),
        require('extras.chests.big-steel-chest-explosion'),
    }
end

return chests