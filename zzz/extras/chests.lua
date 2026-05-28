
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
        require('extras.chests.big-steel-hopper-building'),
        require('extras.chests.big-steel-hopper-item'),
        require('extras.chests.big-steel-hopper-recipe'),
    }
end

function chests.data_updates()

    local tech =  data.raw.technology

    if not enabled('tweaks.earlygame') then
        table.insert(tech['steel-processing'].effects, {
            type = 'unlock-recipe',
            recipe = fns 'big-steel-chest',
        })
    
        table.insert(tech['automation-2'].effects, {
            type = 'unlock-recipe',
            recipe = fns 'big-steel-hopper',
        })
    end
end

function chests.control()
    if not chests.enabled then return end



end

chests.hopper = require 'extras.chests.hopper'

return seal_namespace(chests)