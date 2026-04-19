require 'prelude'

local electroboiler = namespace 'extras.electroboiler'

electroboiler.enabled = true

function electroboiler.data()
    if not electroboiler.enabled then return end

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

return electroboiler:__seal()