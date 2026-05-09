require 'prelude'

local radars = namespace 'extras.radars'

radars.enabled = true

function radars.data()
    if not radars.enabled then return end

    data:extend(require('extras.radars.small-radar'))

    table.insert(data.raw.technology.radar.effects, {
        type = 'unlock-recipe',
        recipe = fns 'small-radar',
    })
end

function radars.data2()
    local ingredient = table.find_matching(data.raw.recipe['artillery-shell'].ingredients,
        { type='item', name = 'radar'}
    )
    assert(ingredient, "artillery-shell recipe has no radar ingredient -- was it already substituted?")
    ingredient.name = fns 'small-radar'
end

return seal_namespace(radars)