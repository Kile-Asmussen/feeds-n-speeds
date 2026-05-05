require 'prelude'

local energy = namespace 'extras.electroboiler'

energy.enabled = true

function energy.data()

    data:extend{
        require 'extras.electroboiler.electroboiler-building',
        require 'extras.electroboiler.electroboiler-item',
        require 'extras.electroboiler.electroboiler-recipe',
    }

    -- Unlock with steam-power technology
    table.insert(data.raw.technology['steam-power'].effects, {
        type = 'unlock-recipe',
        recipe = fns 'electroboiler',
    })
end

return seal_namespace(energy)