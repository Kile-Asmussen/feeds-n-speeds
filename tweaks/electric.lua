require 'prelude'

local electric = namespace('tweaks.electric')

electric.enabled = true

function electric.data_updates()

    if not electric.enabled then return end

    local electric_pole = data.raw['electric-pole']

    local small = electric_pole['small-electric-pole']
    local medium = electric_pole['medium-electric-pole']
    local big = electric_pole['big-electric-pole']
    local substation = electric_pole.substation

    small.maximum_wire_distance = 9.5
    medium.maximum_wire_distance = 15.5
    big.maximum_wire_distance = 50
    substation.maximum_wire_distance = 25

    local tweaks = import 'tweaks'

    if tweaks.concrete.enabled then 
        table.insert(data.raw.technology['electric-energy-distribution-1'].prerequisites, 'concrete')

        table.remove_matching(data.raw.technology['electric-energy-distribution-1'].effects, 
            table.matches{ type = 'unlock-recipe', recipe = 'iron-stick'}
        )

        table.remove_matching(data.raw.recipe['medium-electric-pole'].ingredients,
            table.matches{ type = "item", name = "iron-stick" }
        )

        table.remove_matching(data.raw.recipe['big-electric-pole'].ingredients,
            table.matches{ type = "item", name = "iron-stick" }
        )

        table.insert(data.raw.recipe['medium-electric-pole'].ingredients,
            { type = "item", name = "concrete", amount = 2 }
        )

        table.insert(data.raw.recipe['big-electric-pole'].ingredients,
            { type = "item", name = "concrete", amount = 5 }
        )

        table.insert(data.raw.recipe['substation'].ingredients,
            { type = "item", name = "concrete", amount = 10 }
        )
    end
end

return electric:__seal()