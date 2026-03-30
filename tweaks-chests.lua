require('utils')

tweaks = tweaks or {}
tweaks.chests = tweaks.chests or {}

function tweaks.chests.data_update()

    local container = data.raw.container
    local logistic = data.raw['logistic-container']
    
    for name, chest in pairs (data.raw['logistic-container']) do
        if string.match(name, 'chest') then
            chest.inventory_size = 30
            chest.inventory_type = "with_filters_and_bar"
        end
    end

    container['wooden-chest'].inventory_size = 10
    container['iron-chest'].inventory_size = 20
    container['steel-chest'].inventory_size = 40
end

-- function tweaks.chests.control()
--     script.on_event(defines.events.on_gui_opened,
--         tweaks.chests.sort_chest_on_open)
-- end


-- function tweaks.chests.sort_chest_on_open(event)
--     if event.gui_type == defines.gui_type.entity then
--         local inventory = event.entity.get_inventory(defines.inventory.chest)
--         if inventory and inventory.valid then
--             inventory.sort_and_merge()
--         end
--     end
-- end