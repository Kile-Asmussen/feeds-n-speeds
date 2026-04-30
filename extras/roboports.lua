require 'prelude'

local roboports = namespace 'extras.roboports'

function roboports.data()
    data:extend(require 'extras.roboports.alt-roboports')
end

function roboports.data_updates()
    table.append(data.raw.technology['logistic-robotics'].effects, {
        { type='unlock-recipe', name=fns 'sleeper-roboport' },
    })

    table.append(data.raw.technology['construction-robotics'].effects, {
        { type='unlock-recipe', name=fns 'construction-roboport' },
    })

    table.append(data.raw.technology['logistic-system'].effects, {
        { type='unlock-recipe', name=fns 'logistics-roboport' },
    })
end

return roboports:__seal()