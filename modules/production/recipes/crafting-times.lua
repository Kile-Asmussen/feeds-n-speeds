require 'prelude'

local times = {
    -- Power generation
    ['steam-engine'] = 5.0,
    ['steam-turbine'] = 10.0,
    ['boiler'] = 3.0,
    ['heat-exchanger'] = 8.0,
    ['nuclear-reactor'] = 30.0,
    ['solar-panel'] = 5.0,
    ['accumulator'] = 4.0,

    -- Production
    ['assembling-machine-1'] = 2.0,
    ['assembling-machine-2'] = 5.0,
    ['assembling-machine-3'] = 10.0,
    ['chemical-plant'] = 8.0,
    ['oil-refinery'] = 15.0,
    ['centrifuge'] = 10.0,
    ['steel-furnace'] = 3.0,
    ['electric-furnace'] = 5.0,

    ['burner-mining-drill'] = 3.0,
    ['electric-mining-drill'] = 4.0,
    ['pumpjack'] = 5.0,

    ['roboport'] = 10.0,
    [fns 'sleeper-roboport'] = 1.0
    [fns 'construction-roboport'] = 1.0,
    [fns 'logistics-roboport'] = 1.0,
    ['radar'] = 5.0,
    [fns 'small-radar'] = 3.0,
    ['medium-electric-pole'] = 1.0,
    ['big-electric-pole'] = 2.0,
    ['substation'] = 3.0,
    ['storage-tank'] = 5.0,

    ['wooden-chest'] = 1,
    ['iron-chest'] = 1.5,
    ['steel-chest'] = 1.5,
    [fns 'big-steel-chest'] = 2.5,
    [fns 'big-steel-hopper'] = 2.0,

    ['lab'] = 5.0,

    ['rocket-silo'] = 60.0,
    ['nuclear-reactor'] = 60.0,

    ['recycler'] = 5.0,

    ['locomotive'] = 10.0,
    ['cargo-wagon'] = 8.0,
    ['fluid-wagon'] = 8.0,
    ['artillery-wagon'] = 8.0,

    ['engine-unit'] = 5.0,
    ['electric-engine-unit'] = 5.0,
}

for recipe_name, energy_required in pairs(times) do
    local recipe = data.raw.recipe[recipe_name]
    if recipe then
        recipe.energy_required = energy_required
    end
end