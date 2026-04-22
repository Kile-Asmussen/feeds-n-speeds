require 'prelude'

local technologies = namespace 'tweaks.technologies'

technologies.enabled = true

function technologies.data()
    if enabled('tweaks.earlygame') then
        data:extend{
            require 'tweaks.technologies.lab-technology'
        }
    end
end

function technologies.data_updates()
    if not technologies.enabled then return end


    local tech = data.raw.technology

    -- Gun turret depends on military
    table.insert(tech['gun-turret'].prerequisites, 'military')

    -- Other turrets depend on gun turret
    table.insert(tech['laser-turret'].prerequisites, 'gun-turret')
    table.insert(tech['flamethrower'].prerequisites, 'gun-turret')
    table.insert(tech['artillery'].prerequisites, 'gun-turret')
    table.insert(tech['rocket-turret'].prerequisites, 'gun-turret')


    if enabled('tweaks.earlygame') then
        tech['automation-science-pack'].prerequisites = {
            fns 'lab-tech'
        }

        table.remove_matching(tech['electronics'].effects,
            table.matches{ type='unlock-recipe', recipe='inserter' })
        
        table.remove_matching(tech['electronics'].effects,
            table.matches{ type='unlock-recipe', recipe='lab' })
    end

    technologies.tweak_science_packs()
end

function technologies.tweak_science_packs()
    local recipes = data.raw.recipe

    recipes['automation-science-pack'].ingredients = {
        { type = 'item', name = 'iron-stick', amount = 2 },
        { type = 'item', name = 'electronic-circuit', amount = 1 },
        { type = 'item', name = 'stone-brick', amount = 1 }
    }

    recipes['logistic-science-pack'].ingredients = {
        { type = 'item', name = 'inserter', amount = 1 },
        { type = 'item', name = 'transport-belt', amount = 2 },
        { type = 'item', name = 'small-lamp', amount = 1 },
    }

    

    table.insert(data.raw.technology['logistic-science-pack'].prerequisites, 'lamp')

    recipes['chemical-science-pack'].category = 'crafting-with-fluid'
    recipes['chemical-science-pack'].ingredients = {
        { type = 'item', name = 'engine-unit', amount = 2 },
        { type = 'item', name = 'advanced-circuit', amount = 3 },
        { type = 'item', name = 'concrete', amount = 5 },
        { type = 'fluid', name = 'sulfuric-acid', amount = 10 },
    }

    recipes['production-science-pack'].category = 'crafting-with-fluid'
    recipes['production-science-pack'].ingredients = {
        { type = 'item', name = 'rail', amount = 40 },
        { type = 'item', name = 'substation', amount = 1 },
        { type = 'item', name = 'productivity-module', amount = 1 },
        { type = 'fluid', name = 'steam', amount = 140 },
    }


    local tech = data.raw.technology
    table.insert(tech['production-science-pack'].prerequisites,
        'electric-energy-distribution-2'
    )
    table.remove_matching(tech['production-science-pack'].prerequisites,
        function(v) return v == 'advanced-material-processing-2' end
    )

    recipes['utility-science-pack'].category = 'crafting-with-fluid'
    table.insert(recipes['utility-science-pack'].ingredients,
        { type = 'fluid', name = 'water', amount = 1000 }
    )
end

return technologies:__seal()