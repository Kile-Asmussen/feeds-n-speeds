require 'prelude'

local electric = namespace 'tweaks.electric'

electric.enabled = true

function electric.data_updates()

    if not electric.enabled then return end

    local electric_pole = data.raw['electric-pole']

    local small = electric_pole['small-electric-pole']
    local medium = electric_pole['medium-electric-pole']
    local big = electric_pole['big-electric-pole']
    local substation = electric_pole.substation

    small.maximum_wire_distance = 8.5
    medium.maximum_wire_distance = 10
    big.maximum_wire_distance = 50
    substation.maximum_wire_distance = 22

    table.remove_matching(data.raw.technology['circuit-network'],
        table.matches{type='unlock-recipe', recipe='power-switch'}
    )

    table.insert(data.raw.technology['electric-energy-distribution-2'], { type='unlock-recipe', recipe='power-switch' })

    if enabled('tweaks.concrete') then 
        table.insert(data.raw.technology['electric-energy-distribution-1'].prerequisites, 'concrete')

        table.insert(data.raw.recipe['medium-electric-pole'].ingredients,
            { type = "item", name = "concrete", amount = 1 }
        )

        table.insert(data.raw.recipe['big-electric-pole'].ingredients,
            { type = "item", name = "concrete", amount = 4 }
        )

        if not enabled('tweaks.malltech') then
            table.insert(data.raw.recipe['substation'].ingredients,
                { type = "item", name = "concrete", amount = 10 }
            )
        end
    end
end

return electric:__seal()