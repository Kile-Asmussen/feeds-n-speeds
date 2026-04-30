require 'prelude'

local base = data.raw.roboport.roboport

local sleeper = table.clone(base)
local log_only = table.clone(base)
local cons_only = table.clone(base)

sleeper.material_slots_count = 0
sleeper.robot_slots_count = 14
sleeper.construction_radius = 15
sleeper.logistics_radius = 10
sleeper.charging_energy = "600kW"
sleeper.energy_usage = "25kW"
sleeper.name = fns 'sleeper-roboport'
sleeper.base.layers[1].tint = { 0.9, 0.9, 0.6 }
sleeper.minable.result = sleeper.name

log_only.material_slots_count = 0
log_only.logistics_radius = 25
log_only.construction_radius = 30
log_only.charging_energy = "750kW"
log_only.name = fns 'logistics-roboport'
log_only.base.layers[1].tint = { 1, 0.9, 0.7 }
log_only.minable.result = log_only.name

cons_only.radar_range = 3
cons_only.logistics_radius = 10
cons_only.construction_radius = 65
cons_only.logistics_connection_distance = 25
cons_only.name = fns 'construction-roboport'
cons_only.base.layers[1].tint = { 0.8, 1, 0.8 }
cons_only.minable.result = cons_only.name

local base_item = data.raw.item.roboport

local sleeper_item = table.clone(base_item)
local log_item = table.clone(base_item)
local cons_item = table.clone(base_item)

sleeper_item.icon = nil
sleeper_item.icons = {
    { icon = base_item.icon, icon_size = 64 },
    { icon = data.raw.item['storage-chest'].icon, icon_size = 64, scale = 0.5, floating = true, shift = { 8, -8 } },
}
sleeper_item.name = sleeper.name

log_item.icon = nil
log_item.icons = {
    { icon = base_item.icon, icon_size = 64 },
    { icon = data.raw.item['logistic-robot'].icon, icon_size = 64, scale = 0.5, floating = true, shift = { 8, -8 } },
}
log_item.name = sleeper.name

cons_item.icon = nil
cons_item.icons = {
    { icon = base_item.icon, icon_size = 64 },
    { icon = data.raw.item['construction-robot'].icon, icon_size = 64, scale = 0.5, floating = true, shift = { 8, -8 } },
}
cons_item.name = sleeper.name

local base_recipe = data.raw.recipe.roboport

local sleeper_recipe = table.clone(base_recipe)
local log_recipe = table.clone(base_recipe)
local cons_recipe = table.clone(base_recipe)

sleeper_recipe.name = sleeper.name
sleeper_recipe.results[1].name = sleeper_recipe.name

log_recipe.name = log_only.name
log_recipe.results[1].name = log_recipe.name

cons_recipe.name = cons_only.name
cons_recipe.results[1].name = cons_recipe.name

return {
    sleeper,
    log_only,
    cons_only,
    sleeper_item,
    log_item,
    cons_item,
    sleeper_recipe,
    log_recipe,
    cons_recipe,
}