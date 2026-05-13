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
    altrecipes.foundry_update()
end

function altrecipes.rails()
    -- Concrete rail recipes only with concrete tweaks
    data:extend(require 'extras.altrecipes.concrete-rails')
end

function altrecipes.rail_update()
    if enabled('tweaks.concrete') then
        data.raw.recipe.rail.ingredients = {
            { amount = 6, name = 'stone', type = 'item' },
            { amount = 3, name = 'iron-stick', type = 'item' },
            { amount = 1, name = 'steel-plate', type = 'item' }
        }
        data.raw.recipe.rail.icons = altrecipes.rail_icons('stone')
        table.insert(data.raw.technology['railway'].effects, {
            type='unlock-recipe', recipe=fns 'rail-1'
        })
    end
end
end

function altrecipes.rail_icons(name)
    return {
        { icon = data.raw['rail-planner'].rail.icon, icon_size = 64 },
        { icon = data.raw.item[name].icon, icon_size = 64, scale = 0.25, shift = { -8, -8 } }
    }
end

return seal_namespace(altrecipes)