require 'prelude'

local drills = namespace 'extras.drills'
local debuglib = require 'debuglib'

drills.enabled = true

function drills.data()
    if not drills.enabled then return end

    data:extend{
        require 'extras.drills.burner-mining-drill-fluid-building',
        require 'extras.drills.burner-mining-drill-fluid-item',
        require 'extras.drills.burner-mining-drill-fluid-recipe',
        require 'extras.drills.electric-mining-drill-fluid-building',
        require 'extras.drills.electric-mining-drill-fluid-item',
        require 'extras.drills.electric-mining-drill-fluid-recipe',
        require 'extras.drills.wet-drilling-technology',
    }
    -- Unlock electric drill with fluid alongside regular electric drill
    table.insert(data.raw.technology['electric-mining-drill'].effects, {
        type = 'unlock-recipe',
        recipe = fns 'electric-mining-drill-fluid',
    })

    -- Electric mining drill depends on wet drilling
    table.insert(data.raw.technology['electric-mining-drill'].prerequisites, fns 'wet-drilling')
end

function drills.data2()
    
end

function drills.data_updates()
    if not drills.enabled then return end

    -- Remove fluid input from vanilla electric mining drill
    data.raw['mining-drill']['electric-mining-drill'].input_fluid_box = nil

    drills.fix_uranium_processing(fns 'wet-drilling')
end

function drills.fix_uranium_processing(tech_name)
    local tech = data.raw.technology

    if tech['uranium-mining'].hidden then return end

    tech['uranium-mining'].hidden = true

    -- Convert uranium-processing from trigger-based to science-based
    local uranium = tech['uranium-processing']

    uranium.prerequisites = { tech_name, 'concrete', 'chemical-science-pack' }
    uranium.research_trigger = nil
    uranium.unit = {
        count = 100,
        time = 30,
        ingredients = {
            { 'automation-science-pack', 1 },
            { 'logistic-science-pack', 1 },
            { 'chemical-science-pack', 1 },
        },
    }
end

return seal_namespace(drills)
