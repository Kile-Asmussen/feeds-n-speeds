require 'prelude'

local name = fns 'sulfur-ore'

local noise_expressions = data.raw['noise-expression']

local regular_counts = noise_expressions.default_regular_resource_patch_set_count

noise_expressions[fns 'sulfur-ore-regular-index'].expression = regular_counts.expression
regular_counts.expression = regular_counts.expression + 1

regular_counts = nil

local starting_counts = noise_expressions.default_starting_resource_patch_set_count
noise_expressions[fns 'sulfur-ore-starting-index'].expression = starting_counts.expression
starting_counts.expression = starting_counts.expression + 1

data.raw.planet.nauvis.map_gen_settings.autoplace_controls[fns 'sulfur-ore'] = {}
data.raw.planet.nauvis.map_gen_settings.autoplace_settings.entity.settings[fns 'sulfur-ore'] = {}

table.merge(data.raw.planet.nauvis.map_gen_settings, assoc{
    autoplace_controls = table.writing({}, fns 'sulfur-ore'),
    autoplace_settings = table.writing({}, 'entity', 'settings', fns 'sulfur-ore'),
})