require 'prelude'

local altrecipes = namespace 'extras.altrecipes'

altrecipes.enabled = true

function altrecipes.data()
    if not altrecipes.enabled then return end

    altrecipes.rails()
    altrecipes.stone_furnace()
    altrecipes.concrete_wall()
end

function altrecipes.data_updates()
    if not altrecipes.enabled then return end

    altrecipes.stone_furnace_update()
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

    local recipe = require 'extras.altrecipes.stone-furnace-recipe'

    recipe.enabled = not enabled('tweaks.earlygame')

    data:extend{ recipe }

    if not recipe.enabled then
       data:extend{ require 'extras.altrecipes.basic-materials-processing-technology',}
    end
end

function altrecipes.stone_furnace_update()

    if enabled('tweaks.earlygame') then
        
        data.raw.recipe['burner-mining-drill'].enabled = false
        data.raw.recipe['stone-furnace'].ingredients = {
            { amount = 20, name = 'stone', type = 'item' }
        } 
    else

        data.raw.recipe['stone-furnace'].ingredients = {
            { amount = 10, name = 'stone', type = 'item' }
        }

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