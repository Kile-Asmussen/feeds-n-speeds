require 'prelude'

local chests = namespace 'tweaks.chests'

chests.enabled = true

function chests.data_updates()
    if not chests.enabled then return end

    local extras = import 'extras'

    local container = data.raw.container
    local logistic = data.raw['logistic-container']

    local inventory_sizes = {
        ['wooden-chest'] = 9,
        ['iron-chest'] = 19,
        ['steel-chest'] = 29,
        [fns 'big-steel-chest'] = 69
    }

    local debuglib = import('debuglib')
    for name, chest in pairs(data.raw['logistic-container']) do
        local recipe = data.raw.recipe[name]

        if recipe then
            local base_chest = table.find_matching(
                recipe.ingredients,
                function(t) return inventory_sizes[t.name] end
            )

            local inventory_size = inventory_sizes[base_chest.name]

            if chest.logistic_mode == 'storage' then
                inventory_size = inventory_size - 1
            else
                inventory_size = inventory_size - 11
            end
        
            chest.inventory_size = math.max(inventory_size, 1)
        end
    end

    for name, chest in pairs(data.raw['container']) do
        if inventory_sizes[name] then
            chest.inventory_size = inventory_sizes[name]
        end
    end

    local recipes = data.raw.recipe

    recipes['wooden-chest'].ingredients = { { type='item', name='wood', amount=3 } }
    recipes['iron-chest'].ingredients = { { type='item', name='iron-plate', amount=6 } }
    recipes['steel-chest'].ingredients = { { type='item', name='steel-plate', amount=6 } }

    if enabled 'extras.chests' then
        recipes[fns 'big-steel-chest'].ingredients =  { { type='item', name='steel-plate', amount=24 } }
    end
end

return chests:__seal()