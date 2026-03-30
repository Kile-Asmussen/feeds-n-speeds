require('utils')

tweaks = tweaks or {}
tweaks.nuclear = tweaks.nuclear or {}

function tweaks.nuclear.data_updates()

    if not tweaks.nuclear.enabled then return end

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
