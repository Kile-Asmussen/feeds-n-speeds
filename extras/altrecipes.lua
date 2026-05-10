require 'prelude'

local altrecipes = namespace 'extras.altrecipes'

altrecipes.enabled = true

function altrecipes.data()
    if not altrecipes.enabled then return end

    altrecipes.metallurgy()
    altrecipes.rails()
    altrecipes.stone_furnace()
    altrecipes.concrete_wall()
    altrecipes.ammo()
end

function altrecipes.data2()
    if not altrecipes.enabled then return end

    altrecipes.stone_furnace_update()
    altrecipes.rail_update()
end

function altrecipes.metallurgy()
    data:extend(require 'extras.altrecipes.castings')
end

function altrecipes.rails()
    -- Concrete rail recipes only with concrete tweaks
    if enabled('tweaks.concrete') then
        data:extend(require 'extras.altrecipes.concrete-rails')
    end
end

function altrecipes.rail_update()
    if enabled('tweaks.concrete') then
        data.raw.recipe.rail.ingredients = {
            { amount = 6, name = 'stone', type = 'item' },
            { amount = 3, name = 'iron-stick', type = 'item' },
            { amount = 1, name = 'steel-plate', type = 'item' }
        }
        data.raw.recipe.rail.icons = altrecipes.rail_icons('stone')
    end
end

function altrecipes.ammo()
    if enabled('tweaks.military') then
        data:extend(require 'extras.altrecipes.ammo')
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

    if enabled('tweaks.concrete') then
        data:extend(
            require 'extras.altrecipes.concrete-walling'
        )
    end
end

function altrecipes.rail_icons(name)
    return {
        { icon = data.raw['rail-planner'].rail.icon, icon_size = 64 },
        { icon = data.raw.item[name].icon, icon_size = 64, scale = 0.25, shift = { -8, -8 } }
    }
end

return seal_namespace(altrecipes)