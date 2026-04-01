require 'prelude'

local chests = namespace 'tweaks.chests'

chests.toggle = 'feeds-n-speeds-tweaks-chests-enable'
chests.enabled = true

function chests.data_updates()

    if not chests.enabled then return end

    local container = data.raw.container
    local logistic = data.raw['logistic-container']
    
    for name, chest in pairs (data.raw['logistic-container']) do
        if string.match(name, 'chest') then
            chest.inventory_size = 19
            chest.inventory_type = "with_filters_and_bar"
        end
    end

    container['wooden-chest'].inventory_size = 10
    container['iron-chest'].inventory_size = 10
    container['steel-chest'].inventory_size = 20
end

return chests:__seal()