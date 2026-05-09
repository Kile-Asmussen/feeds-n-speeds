require 'prelude'

local utilities = require 'extras.utilities'
local nuclear = namespace 'tweaks.nuclear'

nuclear.dependencies = table.set{ "tweaks.water" }

nuclear.enabled = true

function nuclear.data2()

    local steam = data.raw.fluid.steam

    local nuclear_reactor = data.raw.reactor['nuclear-reactor']
    local heating_tower = data.raw.reactor['heating-tower']
    local steam_turbine = data.raw.generator['steam-turbine']
    local heat_exchanger = data.raw.boiler['heat-exchanger']

    local ambient_temperature = steam.default_temperature
    local steam_heat_cap = utilities.joules_or_watts( data.raw.fluid.steam.heat_capacity)
    local high_temperature = 500 + ambient_temperature
    local max_temperature = 1000 + ambient_temperature

    steam_turbine.maximum_temperature = high_temperature
    local turbine_output =
        steam_turbine.fluid_usage_per_tick * 60
            * steam_heat_cap * high_temperature

    nuclear_reactor.consumption = utilities.to_watts(10*turbine_output)
    heating_tower.consumption = utilities.to_watts(5*turbine_output)
    heat_exchanger.energy_consumption = utilities.to_watts(2*turbine_output)

    nuclear_reactor.heat_buffer.max_temperature = max_temperature
    heating_tower.heat_buffer.max_temperature = max_temperature

    heat_exchanger.energy_source.max_temperature = max_temperature
    data.raw['heat-pipe']['heat-pipe'].heat_buffer.max_temperature = max_temperature

    heat_exchanger.target_temperature = high_temperature
    heat_exchanger.energy_source.min_working_temperature = high_temperature
    steam_turbine.maximum_temperature = high_temperature
    steam_turbine.energy_source.max_temperature = high_temperature

    heating_tower.scale_energy_usage = true
    heating_tower.localised_description = {"", {fns_locale_key('entity-description', 'tweaked-heating-tower')}}

    nuclear_reactor.scale_energy_usage = true
    nuclear_reactor.localised_description = {"", {fns_locale_key('entity-description', 'tweaked-nuclear-reactor')}}

    nuclear_reactor.neighbour_bonus = 0.5

    data.raw.technology['heating-tower'].localised_description = {"", {fns_locale_key('technology-description', 'tweaked-heating-tower')}}

    data.raw.recipe['acid-neutralisation'].results[1].temperature = high_temperature

    if enabled('tweaks.concrete') and not enabled('tweaks.malltech') then

        local recipe = data.raw.recipe

        table.find_matching(recipe['nuclear-reactor'].ingredients,
            { name = 'concrete', type = 'item' }
        ).name = 'refined-concrete'

        table.insert(recipe['heat-exchanger'].ingredients,
            { type='item', name='concrete', amount=20 }
        )

        table.insert(recipe['steam-turbine'].ingredients,
            { type='item', name='concrete', amount=30 }
        )

    end

    if enabled('tweaks.technologies') then
        table.insert(data.raw.technology['production-science-pack'].prerequisites, 'nuclear-power')

        data.raw.technology['heating-tower'].effects = {
            { type = 'unlock-recipe', recipe='heating-tower' }
        }
    end
end

return seal_namespace(nuclear)