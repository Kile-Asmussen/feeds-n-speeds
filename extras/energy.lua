require 'prelude'

local energy = namespace 'extras.electroboiler'

energy.enabled = true

function energy.data()

    data:extend{
        require 'extras.energy.electroboiler-building',
        require 'extras.energy.electroboiler-item',
        require 'extras.energy.electroboiler-recipe',
    }

    -- Unlock with steam-power technology
    table.insert(data.raw.technology['steam-power'].effects, {
        type = 'unlock-recipe',
        recipe = fns 'electroboiler',
    })
end

return seal_namespace(energy)