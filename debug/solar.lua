
local fns = require 'fns'

local gadgets = fns.gadgets
local table = fns.table

local debuglib = require 'debuglib'
require 'test'

debuglib.recursion_limit = 10
begin_data_stage()

local default = {}

for name, prop in pairs(data.raw['surface-property']) do
    default[name] = prop.default_value
end

local panel = data.raw['solar-panel']['solar-panel']

local output = gadgets.joules_or_watts(panel.production)

local planets = {}

local daytime_parameters = { dawn = 0.75, dusk = 0.25, evening = 0.45, morning = 0.55 }

for name, planet in pairs(data.raw.planet) do
    planet = table.deepcopy(planet.surface_properties)
    planets[name] = planet
    table.include(planet, default)

    local seconds = planet['day-night-cycle'] / 60
    local production = output * (planet['solar-power'] / 100)

    local day_fraction = (daytime_parameters.dusk + (1 - daytime_parameters.dawn))
    local sunset_fraction = (daytime_parameters.evening - daytime_parameters.dusk)
    local sunrise_fraction = (daytime_parameters.dawn - daytime_parameters.morning)
    local night_fraction = (daytime_parameters.morning - daytime_parameters.evening)

    local day_length = day_fraction * seconds
    local sunset_length = sunset_fraction * seconds
    local sunrise_length = sunrise_fraction * seconds
    local night_length = night_fraction * seconds
    
    local day_production = production * day_fraction
    local sunset_production = (production / 2) * sunset_fraction
    local sunrise_production = (production / 2) * sunrise_fraction

    local average_production = day_production + sunset_production + sunrise_production

    table.merge(planet, {
        ['solar-panel'] = {
            peak_production = gadgets.to_watts(production),
            average_production = gadgets.to_watts(average_production),
            total_energy_per_cycle = gadgets.to_joules(average_production * seconds)
        },
        ['day-night-cycle'] = {
            total = seconds,
            day = day_length,
            sunset = sunset_length,
            sunrise = sunrise_length,
            night = night_length,
        },
        ['daytime-parameters'] = table.collect(daytime_parameters, function(n) return n * seconds end),
    })
end

print(debuglib.pp(planets, 'planets'))
