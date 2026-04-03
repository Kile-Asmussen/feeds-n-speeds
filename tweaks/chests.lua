require 'prelude'

local chests = namespace 'tweaks.chests'

chests.toggle = 'feeds-n-speeds-tweaks-chests-enable'
chests.enabled = true

function chests.data_updates()

    if not chests.enabled then return end

    local container = data.raw.container
    local logistic = data.raw['logistic-container']
    
    for name, chest in pairs (data.raw['logistic-container']) do
        if name:match('chest') then
            chest.inventory_size = 18
            chest.inventory_type = "with_filters_and_bar"
        end
    end

    container['wooden-chest'].inventory_size = 9
    container['iron-chest'].inventory_size = 9
    container['steel-chest'].inventory_size = 19

    if container['big-steel-chest'] then
        container['big-steel-chest'].inventory_size = 39
    end
end

return chests:__seal()