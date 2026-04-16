require 'prelude'

local altrecipes = namespace 'extras.altrecipes'

altrecipes.enabled = true

function altrecipes.data()

    data:extend(
        require 'extras.altrecipes.rail-recipes'
    )

    data:extend(
        require 'extras.altrecipes.stone-furnace-recipes'
    )

end