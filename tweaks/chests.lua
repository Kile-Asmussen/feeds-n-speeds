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
    }

    if extras.chests.enabled then
        inventory_sizes[fns 'big-steel-chest'] = 69
        inventory_sizes[fns 'smart-big-steel-chest'] = 67
    end

    
    for name, chest in pairs(data.raw['logistic-container']) do
        local recipe = data.raw.recipe[name]

        if recipe then
            local inventory_size = table.find_matching(
                recipe.ingredients,
                function(t) return inventory_sizes[t.name] end
            )

            local adjustment = 11
            if chest.logistic_mode == 'storage' then
                adjustment = 1
            end
        
            if type(inventory_size) == 'number' then
                chest.inventory_size = math.max(inventory_size - adjustment, 1)
            end
        end
    end

    for name, chest in pairs(data.raw['container']) do
        if inventory_sizes[name] then
            chest.inventory_size = inventory_sizes[name]
        end
    end
end

return chests:__seal()