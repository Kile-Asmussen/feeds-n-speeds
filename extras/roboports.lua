require 'prelude'

local roboports = namespace 'extras.roboports'
roboports.enabled = true

function roboports.data()
    if not roboports.enabled then return end
    data:extend(require 'extras.roboports.alt-roboports')
end

function roboports.data_updates()
    if not roboports.enabled then return end
    table.append(data.raw.technology['logistic-robotics'].effects, {
        { type='unlock-recipe', recipe=fns 'sleeper-roboport' },
    })

    table.append(data.raw.technology['construction-robotics'].effects, {
        { type='unlock-recipe', recipe=fns 'construction-roboport' },
    })

    table.append(data.raw.technology['logistic-system'].effects, {
        { type='unlock-recipe', recipe=fns 'logistics-roboport' },
    })
end

return roboports:__seal()