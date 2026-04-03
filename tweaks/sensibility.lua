require 'prelude'

local sensibility = namespace 'tweaks.sensibility'

sensibility.enabled = true

function sensibility.data_updates()

    if not sensibility.enabled then return end

    table.insert(data.raw.recipe['electric-furnace'].ingredients, { name = 'concrete', type = 'item', amount = 10 })
    table.insert(data.raw.technology['advanced-material-processing-2'].prerequisites, 'concrete')
end

return sensibility:__seal()