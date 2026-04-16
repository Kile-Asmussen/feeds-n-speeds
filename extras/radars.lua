require 'prelude'

local radars = namespace 'extras.radars'

radars.enabled = true

function radars.data()
    if not radars.enabled then return end

    data:extend{
        require('extras.radars.small-radar-building'),
        require('extras.radars.small-radar-item'),
        require('extras.radars.small-radar-recipe'),
        require('extras.radars.small-radar-remnants'),
        require('extras.radars.small-radar-explosion'),
    }


    table.insert(data.raw.technology.radar.effects, {
        type = 'unlock-recipe',
        recipe = fns 'small-radar',
    })

    table.find_matching(data.raw.recipe['artillery-shell'].ingredients,
        table.matches{ type='item', name = 'radar'}
    ).name = fns 'small-radar'
end

return radars:__seal()