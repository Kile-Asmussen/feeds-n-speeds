--! data: changes to ratios and potency of nuclear power

local fns = require 'fns'

local steam = data.raw.fluid.steam
local water = data.raw.fluid.water

local nuclear_reactor = data.raw.reactor['nuclear-reactor']
local heating_tower = data.raw.reactor['heating-tower']
local steam_turbine = data.raw.generator['steam-turbine']
local heat_exchanger = data.raw.boiler['heat-exchanger']

local ambient_temperature = steam.default_temperature
local steam_heat_cap = fns.gadgets.joules_or_watts( data.raw.fluid.steam.heat_capacity)
local high_temperature = 500 + ambient_temperature
local max_temperature = 1000 + ambient_temperature

steam_turbine.maximum_temperature = high_temperature
local turbine_output =
    steam_turbine.fluid_usage_per_tick * 60
        * steam_heat_cap * high_temperature

nuclear_reactor.consumption = fns.gadgets.to_watts(10*turbine_output)
heating_tower.consumption = fns.gadgets.to_watts(5*turbine_output)
heat_exchanger.energy_consumption = fns.gadgets.to_watts(2*turbine_output)

for _, reactor in ipairs {nuclear_reactor, heating_tower} do
    reactor.heat_buffer.min_working_temperature = water.max_temperature
    reactor.heat_buffer.max_temperature = max_temperature
end

heat_exchanger.energy_source.max_temperature = max_temperature
data.raw['heat-pipe']['heat-pipe'].heat_buffer.max_temperature = max_temperature

heat_exchanger.target_temperature = high_temperature
heat_exchanger.energy_source.min_working_temperature = high_temperature
steam_turbine.maximum_temperature = high_temperature
steam_turbine.energy_source.max_temperature = high_temperature

-- heating_tower.localised_description = {fns.locale_key('entity-description', 'tweaked-heating-tower')}
-- nuclear_reactor.localised_description = {fns.locale_key('entity-description', 'tweaked-nuclear-reactor')}

nuclear_reactor.neighbour_bonus = 0.5

-- data.raw.technology['heating-tower'].localised_description = {fns.locale_key('technology-description', 'tweaked-heating-tower')}

data.raw.recipe['acid-neutralisation'].results[1].temperature = high_temperature

table.merge( data.raw.technology, {
    __rec = true,
    ['nuclear-power'] = {
        unit = { __merge = true, ingredients = {
            { 'automation-science-pack', 1 },
            { 'logistic-science-pack', 1 },
            { 'chemical-science-pack', 1 },
            { 'production-science-pack', 1 },
        }},
        prerequisites = table.append{ fns 'electric-heater' },
    },

    ['heating-tower'] = {
        prerequisites = table.append{ fns 'electric-heater' },
    }
})

table.merge(data.raw.recipe, {
    __rec = true,
    ['heat-exchanger'] = { auto_unlocked_by = { 'nuclear-power', 'heating-tower' } },
    ['steam-turbine'] = { auto_unlocked_by = { 'nuclear-power', 'heating-tower' } },
})

data.raw['heat-pipe']['heat-pipe'].heat_buffer.specific_heat = "25kJ"
data.raw['heat-pipe']['heat-pipe'].heat_buffer.max_transfer = "1GW"

data.raw.boiler['heat-exchanger'].energy_source.specific_heat = "250kJ"
data.raw.reactor['heating-tower'].heat_buffer.specific_heat = "1MJ"
data.raw.reactor['nuclear-reactor'].heat_buffer.specific_heat = "2MJ"

data.raw.boiler['heat-exchanger'].energy_source.max_transfer = "2GW"
data.raw.reactor['heating-tower'].heat_buffer.max_transfer = "4GW"
data.raw.reactor['nuclear-reactor'].heat_buffer.max_transfer = "8GW"