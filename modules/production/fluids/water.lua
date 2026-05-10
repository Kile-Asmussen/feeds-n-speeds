require 'prelude'

local tools = require 'tools'

local fluids = data.raw.fluid
local water = fluids.water
local steam = fluids.steam

water.default_temperature = 15
water.max_temperature = 100

steam.default_temperature = 0
steam.gas_temperature = 100
steam.max_temperature = 1500

local plant = data.raw['assembling-machine']['chemical-plant']

local heat_cap = tools.joules_or_watts(steam.heat_capacity)
local power = tools.joules_or_watts(plant.energy_usage)
local boil_water = data.raw.recipe[fns 'boil-water']

local zero = steam.default_temperature
local boil = steam.gas_temperature
local diff = boil - zero
local energy_1 = heat_cap * diff
local energy = energy_1 * boil_water.results[1].amount
local proper_time = energy / power
local time = proper_time / plant.crafting_speed

boil_water.results[1].temperature = boil
boil_water.energy_required = math.ceil(time)

tools.remove_unlock('chemical-plant')

table.append(data.raw.technology['fluid-handling'].effects, {
    { type='unlock-recipe', recipe='chemical-plant' },
    { type='unlock-recipe', recipe=fns 'boil-water' },
})