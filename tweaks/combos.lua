require 'prelude'

local tweaks = require 'tweaks'

local combos = namespace 'tweaks.combos'

combos.toggle = 'feeds-n-speeds-tweaks-combos-enable'
combos.enabled = true

combos.priority = -100

function combos.data_updates()

    if not combos.enabled then return end

    if tweaks.concrete.enabled and tweaks.electric.enabled then
        combos.electric_on_concrete()
    end

    if tweaks.concrete.enabled and tweaks.nuclear.enabled then
        combos.electric_on_concrete()
    end
end

function combos.electric_on_concrete()

    local recipes = data.raw.recipe
    local tech = data.raw.technology

    table.insert(tech['electric-energy-distribution-1'].prerequisites, 'concrete')

    table.remove_matching(tech['electric-energy-distribution-1'].effects, 
        table.matches{ type = 'unlock-recipe', recipe = 'iron-stick'}
    )

    table.remove_matching(recipes['medium-electric-pole'].ingredients,
        table.matches{ type = "item", name = "iron-stick" }
    )

    table.remove_matching(recipes['big-electric-pole'].ingredients,
        table.matches{ type = "item", name = "iron-stick" }
    )

    table.insert(recipes['medium-electric-pole'].ingredients,
        { type = "item", name = "concrete", amount = 2 }
    )

    table.insert(recipes['big-electric-pole'].ingredients,
        { type = "item", name = "concrete", amount = 5 }
    )

    table.insert(recipes['substation'].ingredients,
        { type = "item", name = "concrete", amount = 10 }
    )

end

function combos.nuclear_concrete()
        -- Unfortunately to make electric furnaces depend on concrete, we gotta
    -- make the tech depend on it as well


end

function combos.rebalance_concrete()
    table.insert(recipes['electric-furnace'].ingredients, { name = 'concrete', type = 'item', amount = 10 })
    table.insert(tech['advanced-material-processing-2'].prerequisites, 'concrete')
end

return combos:__seal()