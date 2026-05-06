requre 'prelude'

local cliffsplosives = namespace 'tweaks.cliffsplosive'
cliffsplosives.enabled = true

function cliffsplosives.data2()

    local cliffs = data.raw.technology['cliff-explosives']

    cliffs.unit = {
        time = 30,
        count = 500,
        ingredients = {
            { 'automation-science-pack', 1 },
            { 'logistic-science-pack', 1 },
            { 'chemical-science-pack', 1 },
            { 'military-science-pack', 1 },
            { 'utility-science-pack', 1 },
        }
    }

    cliffs.prerequisites = { 'military-4' }
end