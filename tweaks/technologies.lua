require 'prelude'

local technologies = namespace 'tweaks.technologies'

technologies.enabled = true

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

    technologies.tweak_science_packs()
end

function technologies.tweak_science_packs()
    local recipes = data.raw.recipe

    table.insert(recipes['automation-science-pack'].ingredients,
        { type = 'item', name = 'stone', amount = 1 }
    )

    table.insert(recipes['logistic-science-pack'].ingredients,
        { type = 'item', name = 'pipe', amount = 1 }
    )

    recipes['chemical-science-pack'].category = 'crafting-with-fluid'
    table.remove_matching(recipes['chemical-science-pack'].ingredients,
        table.matches{ name = 'sulfur' }
    )
    table.insert(recipes['chemical-science-pack'].ingredients,
        { type = 'fluid', name = 'sulfuric-acid', amount = 10 }
    )

    table.find_matching(recipes['production-science-pack'].ingredients,
        table.matches{ name = 'electric-furnace' }
    ).name = 'substation'

    recipes['production-science-pack'].category = 'crafting-with-fluid'
    table.insert(recipes['production-science-pack'].ingredients,
        { type = 'fluid', name = 'steam', amount = 140 }
    )

    local tech = data.raw.technology
    table.insert(tech['production-science-pack'].prerequisites,
        'electric-energy-distribution-2'
    )
    table.remove_matching(tech['production-science-pack'].prerequisites,
        function(v) return v == 'advanced-material-processing-2' end
    )

    recipes['utility-science-pack'].category = 'crafting-with-fluid'
    table.insert(recipes['utility-science-pack'].ingredients,
        { type = 'fluid', name = 'water', amount = 2800 }
    )

    local assemblers = data.raw['assembling-machine']
    assemblers['assembling-machine-2'].fluid_boxes[1].volume = 3000
    assemblers['assembling-machine-3'].fluid_boxes[1].volume = 3000
end

return technologies:__seal()