require 'prelude'

local technologies = namespace 'tweaks.technologies'

technologies.enabled = true

function technologies.data()

end

function technologies.data_updates()
    if not technologies.enabled then return end

    local tech = data.raw.technology

    table.insert(tech['logistic-science-pack'].prerequisites, 'logistics')
    table.insert(tech['uranium-mining'].prerequisites, 'electric-mining-drill')

    if enabled('tweaks.earlygame') then
        tech['automation-science-pack'].prerequisites = {
            fns 'lab-tech'
        }

        table.remove_matching(tech['electronics'].effects,
            table.matches{ type='unlock-recipe', recipe='inserter' })
        
        table.remove_matching(tech['electronics'].effects,
            table.matches{ type='unlock-recipe', recipe='lab' })

        if not enabled('tweaks.timewaster') then
            table.insert(tech[fns 'basic-materials-processing'].effects,
                {
                    modifier = 0.5,
                    type = 'character-mining-speed'
                }
            )
            table.find_matching(tech['steel-axe'].effects, {type='character-mining-speed'}).modifier = 0.5
        end
    end

    if enabled('tweaks.concrete') then
        tech['automated-rail-transportation'].unit = nil
        tech['automated-rail-transportation'].research_trigger = {
            type = 'craft-item',
            item = 'rail',
            count = 1000,
        }
    end

    technologies.tweak_science_packs()
end

function technologies.tweak_science_packs()
    local recipes = data.raw.recipe

    recipes['automation-science-pack'].ingredients = {
        { type = 'item', name = 'iron-plate', amount = 2 },
        { type = 'item', name = 'copper-plate', amount = 2 },
        { type = 'item', name = 'stone-brick', amount = 1 }
    }

    if enabled('tweaks.earlygame', 'extras.drills', 'extras.ores') then
        table.insert(recipes['automation-science-pack'].ingredients,
        { type = 'item', name = 'sulfur', amount = 1  })
    else
        table.insert(recipes['automation-science-pack'].ingredients,
        { type = 'item', name = 'coal', amount = 1  })
    end

    recipes['logistic-science-pack'].ingredients = {
        { type = 'item', name = 'inserter', amount = 1 },
        { type = 'item', name = 'transport-belt', amount = 1 },
        { type = 'item', name = 'small-lamp', amount = 1 },
        { type = 'item', name = 'pipe', amount = 1 },
    }

    table.insert(data.raw.technology['logistic-science-pack'].prerequisites, 'lamp')

    recipes['chemical-science-pack'].category = 'crafting-with-fluid'
    recipes['chemical-science-pack'].ingredients = {
        { type = 'item', name = 'engine-unit', amount = 2 },
        { type = 'item', name = 'advanced-circuit', amount = 3 },
        { type = 'item', name = 'concrete', amount = 10 },
        { type = 'fluid', name = 'sulfuric-acid', amount = 10 },
    }

    recipes['military-science-pack'].category = 'crafting-with-fluid'
    recipes['military-science-pack'].ingredients = {
        { type = 'item', name = 'piercing-rounds-magazine', amount = 1 },
        { type = 'item', name = 'grenade', amount = 1 },
        { type = 'item', name = 'stone-wall', amount = 2 },
        { type = 'fluid', name = 'crude-oil', amount = 10 },
    }

    table.append(data.raw.technology['military-science-pack'].prerequisites, 
        { 'automation-2', 'oil-gathering' }
    )

    recipes['production-science-pack'].category = 'crafting-with-fluid'
    recipes['production-science-pack'].ingredients = {
        { type = 'item', name = 'rail', amount = 40 },
        { type = 'item', name = 'substation', amount = 1 },
        { type = 'item', name = 'productivity-module', amount = 1 },
        { type = 'fluid', name = 'steam', amount = 200 },
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

return seal_namespace(technologies)