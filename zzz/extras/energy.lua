require 'prelude'

local energy = namespace 'extras.electroboiler'

energy.enabled = true

function energy.data()

    data:extend(require 'extras.energy.electroboiler')

    data:extend(require 'extras.energy.electric-link')
end

function energy.data2()
    -- Unlock with steam-power technology
    table.insert(data.raw.technology['fluid-handling'].effects, {
        type = 'unlock-recipe',
        recipe = fns 'electroboiler',
    })

    table.insert(data.raw.technology['electric-energy-distribution-2'].effects, {
        type = 'unlock-recipe',
        recipe = fns 'electric-link'
    })
end

return seal_namespace(energy)