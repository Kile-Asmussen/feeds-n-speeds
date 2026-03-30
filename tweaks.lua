require('utils')

tweaks = {
    inserter = {},
    nuclear = {},
    concrete = {},
}

function tweaks.inserter.data_update()

    inserter = data.raw.inserter

    -- The red inserter is precisely half as fast as the fast inserter
    -- as well as twice as fast as the burner inserter

    -- This is not true of the yellow inserter, so let's fix that
    inserter.inserter.extension_speed = inserter['long-handed-inserter'].extension_speed
    inserter.inserter.rotation_speed = inserter['long-handed-inserter'].rotation_speed

    -- It's also annoying that inserters chase belts
    for inserter_name, inserter_data in pairs(data.raw.inserter) do
        inserter_data.chases_belt_items = false
    end
end 


function tweaks.nuclear.data_update()
    -- A lot of the ratios are caused by the wonky temperature
    -- difference between ambient and max of 985 degrees
    local ambient_temperature = 15
    local high_temperature = 500 + ambient_temperature
    local max_temperature = 1000 + ambient_temperature

    -- Steam energy content is calculated as a function of
    -- its temperature above ambient temperature
    data.raw.fluid.steam.max_temperature = max_temperature

    local nuclear_reactor = data.raw.reactor['nuclear-reactor']
    local steam_turbine = data.raw.generator['steam-turbine']
    local heat_exchanger = data.raw.boiler['heat-exchanger']

    -- Heat buffers work at the same temperature as steam
    -- (maybe they use water as a working fluid?)
    nuclear_reactor.heat_buffer.max_temperature = max_temperature
    heat_exchanger.energy_source.max_temperature = max_temperature
    data.raw['heat-pipe']['heat-pipe'].heat_buffer.max_temperature = max_temperature

    -- Energy production happens at 500 above ambient temperature
    -- for nice numbers
    heat_exchanger.target_temperature = high_temperature
    heat_exchanger.energy_source.min_working_temperature = high_temperature
    steam_turbine.maximum_temperature = high_temperature
    steam_turbine.energy_source.max_temperature = high_temperature

    -- Nuclear reactors are 'dumb' and burn fuel constantly
    -- It presents a challenge, sure, but feels inconsistent with
    -- every other avenue of power generation being 'smart'
    nuclear_reactor.scale_energy_usage = true

    -- Energy output of a nuclear reactor is buffed slightly
    -- Coincidentally, an 8 GJ nuclear fuel cell will last
    -- precisely 8000 ticks
    -- 1 Reactor : 5 HX
    nuclear_reactor.consumption = '60MW'
    heat_exchanger.energy_consumption = '12MW'

    -- Neighbor bonus of 50% rather than 100%, meaning to count
    -- 'effective reactors' one need only count each reactor and
    -- each each interface between two adjacent reactors
    nuclear_reactor.neighbour_bonus = 0.5
end

function tweaks.concrete.data_update()

    local recipes = data.raw.recipe
    local tech = data.raw.technology

    -- In real life, production of concrete is a delicate operation with
    -- a lot of fine chemistry going into it. To reflect this, let's change
    -- the recipe a bit, and also get rid of that pesky iron ore that's here
    -- for no reason. Iron sticks will serve as the reinforcement.

    recipes.concrete.category = 'chemistry'
    recipes.concrete.ingredients = {
        { type = 'item', name = 'stone-brick', amount = 5 },
        { type = 'item', name = 'iron-stick', amount = 2 },
        { type = 'fluid', name = 'water', amount = 100 },
    }

    -- Refined concrete is then reinforced with additional steel for strength.
    
    recipes['refined-concrete'].category = 'chemistry'
    recipes['refined-concrete'].ingredients = {
        { type = 'item', name = 'concrete', amount = 20 },
        { type = 'item', name = 'steel-plate', amount = 2 },
        { type = 'fluid', name = 'water', amount = 100 },
    }

    -- Next we alter research of concrete so we unlock
    -- the chemical plant to produce it in.

    table.insert(tech.concrete.effects, {
        type = 'unlock-recipe',
        recipe = 'chemical-plant'
    })

    table.insert(tech.concrete.prerequisites, 'fluid-handling')

    -- We also make sure to make oil processing depend on concrete


    table.insert(tech['oil-processing'].prerequisites, 'concrete')

    -- And remove that it unlocks the chemical plant, making concrete
    -- a mandatory technology! First we gotta find where it is in the list, though:

    table.remove_matching(tech['oil-processing'].effects, function(effect) do
        return effect.type == 'unlock-recipe' and effect.recipe == 'chemical-plant'
    end)

    -- Finally we make a few recipes dependent on concrete instead of bricks

    is_stone_brick = is_ingredient('stone-brick')

    table.find_matching(recipes['oil-refinery'].ingredients, is_stone_brick).name = 'concrete'

    -- Unfortunately to make electric furnaces depend on concrete, we gotta
    -- make the tech depend on it as well

    table.find_matching(recipes['electric-furnace'].ingredients, is_stone_brick).name = 'concrete'
    table.insert(tech['advanced-material-processing-2'].prerequisites, 'concrete')

    -- And make the nuclear reactor dependent on refined concrete

    conc = table.find_matching(recipes['nuclear-reactor'].ingredients, is_ingredient('concrete'))
    conc.name = 'refined-concrete'
    conc.amount = 1000

    table.find_matching(recipes['nuclear-reactor'].ingredients, is_ingredient('steel-plate')).amount = 200

end

tweaks.chests = {}

function tweaks.chests.data_update()

    local container = data.raw.container
    local logistic = data.raw['logistic-container']

    
    for _,chest in pairs (data.raw['logistic-container']) do
        if string.find(name, 'chest') then
            chest.inventory_size = 30
            chest.inventory_type = "with_filters_and_bar"
        end
    end
    
    -- Set the inventory type to enable 

    container['wooden-chest'].inventory_type = "with_filters_and_bar"
    container['iron-chest'].inventory_type = "with_filters_and_bar"
    container['steel-chest'].inventory_type = "with_filters_and_bar"

    container['wooden-chest'].inventory_size = 10
    container['iron-chest'].inventory_size = 20
    container['steel-chest'].inventory_size = 40
end

function tweaks.chests.control()

    function sort_chest_on_open(event)
        if event.gui_type == defines.gui_type.entity then
            local inventory = event.entity.get_inventory(defines.inventory.chest)
            if inventory and inventory.valid then
                inventory.sort_and_merge()
            end
        end
    end

    script.on_event(defines.events.on_gui_opened, sort_chest_on_open)
end