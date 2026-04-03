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
end

function radars.data_updates()

    if not radars.enabled then return end

    table.insert(data.raw.technology.radar.effects, {
        type = 'unlock-recipe',
        recipe = 'small-radar',
    })

end

return radars:__seal()