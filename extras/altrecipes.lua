require 'prelude'

local altrecipes = namespace 'extras.altrecipes'

altrecipes.enabled = true

function altrecipes.data()
    if not altrecipes.enabled then return end

    data.raw.recipe.rail.ingredients = {
        { amount = 2, name = 'stone', type = 'item' },
        { amount = 2, name = 'iron-stick', type = 'item' },
        { amount = 1, name = 'steel-plate', type = 'item' }
    }

    data:extend{
        require 'extras.altrecipes.rail-recipes'
    }

    data:extend{
        require 'extras.altrecipes.concrete-rail-technology'
    }

    data:extend(
        require 'extras.altrecipes.stone-furnace-recipes'
    )

end

return altrecipes:__seal()