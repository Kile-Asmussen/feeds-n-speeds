require 'prelude'

local utilities = require 'extras.utilities'


local water = namespace 'tweaks.water'
water.enabled = true

function water.data()
    data:extend(require 'tweaks.water.boil-water')
end

function water.data2()

    local fluids = data.raw.fluid
    local water = fluids.water
    local steam = fluids.steam

    water.default_temperature = 15
    water.max_temperature = 100

    steam.default_temperature = 0
    steam.gas_temperature = 100
    steam.max_temperature = 1500

    local plant = data.raw['asssembling-machine']['chemical-plant']

    local heat_cap = utilities.joules_or_watts(steam.heat_capacity)

    local power = utilities.joules_or_watts(plant.energy_usage)

    local zero = steam.default_temperature
    local boil = steam.gas_temperature
    local diff = boil - zero
    local energy = heat_cap * diff
    local proper_time = energy / power
    local time = proper_time / plant.crafting_speed

    data.raw.recipe[fns 'boil-water'].energy_required = time

    utilities.remove_unlock('chemical-plant')

    table.insert(data.raw.technology['fluid-handling'], 'chemical-plant', 1)
end


return seal_namespace(water)