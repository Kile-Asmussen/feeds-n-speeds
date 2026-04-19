require 'prelude'

local altrecipes = namespace 'extras.altrecipes'

altrecipes.enabled = true

function altrecipes.data()
    if not altrecipes.enabled then return end

    altrecipes.rails()
    altrecipes.stone_furnace()
    altrecipes.concrete_wall()
end

function altrecipes.rails()
    local tweaks = import 'tweaks'

    data.raw.recipe.rail.ingredients = {
        { amount = 2, name = 'stone', type = 'item' },
        { amount = 2, name = 'iron-stick', type = 'item' },
        { amount = 1, name = 'steel-plate', type = 'item' }
    }

    -- Stone-brick rail always available with railway
    data:extend{
        require 'extras.altrecipes.rail-1-recipe',
    }

    table.insert(data.raw.technology.railway.effects,
        { type = 'unlock-recipe', recipe = fns 'rail-1' }
    )

    -- Concrete rail recipes only with concrete tweaks
    if tweaks.concrete.enabled then
        data:extend{
            require 'extras.altrecipes.rail-2-recipe',
            require 'extras.altrecipes.rail-3-recipe',
            require 'extras.altrecipes.concrete-rail-technology',
        }
    end
end

function altrecipes.stone_furnace()
    local tweaks = import 'tweaks'

    local recipe = require 'extras.altrecipes.stone-furnace-recipe'

    if tweaks.earlygame.enabled then
        -- With earlygame: expensive vanilla, brick recipe locked behind tech
        data.raw.recipe['stone-furnace'].ingredients = {
            { amount = 15, name = 'stone', type = 'item' }
        }

        recipe.enabled = false

        data:extend{
            recipe,
            require 'extras.altrecipes.basic-materials-processing-technology',
        }
    else
        -- Without earlygame: modest vanilla cost, brick recipe available from start
        data.raw.recipe['stone-furnace'].ingredients = {
            { amount = 10, name = 'stone', type = 'item' }
        }

        recipe.enabled = true

        data:extend{ recipe }
    end
end

function altrecipes.concrete_wall()
    local tweaks = import 'tweaks'

    if tweaks.concrete.enabled then
        data:extend{
            require 'extras.altrecipes.concrete-wall-recipe',
            require 'extras.altrecipes.concrete-wall-technology',
        }
    end
end

return altrecipes:__seal()