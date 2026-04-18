require 'prelude'

local altrecipes = namespace 'extras.altrecipes'

altrecipes.enabled = true

function altrecipes.data()
    if not altrecipes.enabled then return end

    altrecipes.rails()
    altrecipes.stone_furnace()

end

function altrecipes.rails()
    data.raw.recipe.rail.ingredients = {
        { amount = 2, name = 'stone', type = 'item' },
        { amount = 2, name = 'iron-stick', type = 'item' },
        { amount = 1, name = 'steel-plate', type = 'item' }
    }

    data:extend{
        require 'extras.altrecipes.rail-1-recipe',
        require 'extras.altrecipes.rail-2-recipe',
        require 'extras.altrecipes.rail-3-recipe',
    }

    data:extend{
        require 'extras.altrecipes.concrete-rail-technology'
    }
end

function altrecipes.stone_furnace()

    data:extend{
        require 'extras.altrecipes.stone-furnace-recipe'
    }

    data.raw.recipe['stone-furnace'].ingredients = {
        { amount = 5, name = 'stone-brick', type = 'item' }
    }

end

return altrecipes:__seal()