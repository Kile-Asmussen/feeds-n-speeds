require 'prelude'

local ores = namespace 'extras.ores'

ores.enabled = true

function ores.data()
    if not ores.enabled then return end

    data:extend{
        require 'extras.ores.sulfur-ore',
        require 'extras.ores.sulfur-ore-autoplace-control',
        require 'extras.ores.sulfur-ore-noise-expression',
    }
end

function ores.data_updates()
    if not ores.enabled then return end

    -- Register sulfur ore with Nauvis map generation
    local nauvis = data.raw.planet.nauvis
    if nauvis and nauvis.map_gen_settings then
        nauvis.map_gen_settings.autoplace_controls[fns 'sulfur-ore'] = {}
    end
end

return ores:__seal()