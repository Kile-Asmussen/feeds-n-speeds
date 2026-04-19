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

return ores:__seal()