require 'prelude'

local utilities = require 'extras.utilities'


local water = namespace 'tweaks.water'
water.enabled = true
water.dependencies = table.set{'tweaks.sulfur-processing'}

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

    local plant = data.raw['assembling-machine']['chemical-plant']

    local heat_cap = utilities.joules_or_watts(steam.heat_capacity)
    local power = utilities.joules_or_watts(plant.energy_usage)
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

    utilities.remove_unlock('chemical-plant')

    table.append(data.raw.technology['fluid-handling'].effects, {
        { type='unlock-recipe', recipe='chemical-plant' },
        { type='unlock-recipe', recipe=fns 'boil-water' },
    })

    for _, rec in ipairs{
        fns 'purifying-heavy-oil-cracking-processing',
        fns 'purifying-advanced-oil-processing',
        'heavy-oil-cracking',
        'light-oil-cracking',
        'advanced-oil-processing',
    } do
        rec = data.raw.recipe[rec]
        if rec then
            table.find_matching(rec.ingredients, {type='fluid',name='water'}).name='steam'
        end
    end
end


return seal_namespace(water)