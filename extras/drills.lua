require 'prelude'

local drills = namespace 'extras.drills'

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
end

function drills.data_updates()
    if not drills.enabled then return end

    -- Remove fluid input from vanilla electric mining drill
    data.raw['mining-drill']['electric-mining-drill'].input_fluid_box = nil
end

return drills:__seal()
