-- data: dynamically add sulfur ore to resource patch sets
local fns = require 'fns'
local name = fns 'sulfur-ore'
local merge = fns.table.merge

local noise_expressions = data.raw['noise-expression']

local regular_counts = noise_expressions.default_regular_resource_patch_set_count
local starting_counts = noise_expressions.default_starting_resource_patch_set_count

regular_counts.expression = regular_counts.expression + 1
starting_counts.expression = starting_counts.expression + 1

merge(noise_expressions, {
    __rec = true,
    [fns 'sulfur-ore-regular-index'] = { expression = regular_counts.expression },
    [fns 'sulfur-ore-starting-index'] = { expression = starting_counts.expression },
})

merge(data.raw.planet.nauvis.map_gen_settings, {
    autoplace_controls = table.assign{ fns 'sulfur-ore', val = {}},
    autoplace_settings = table.assign{'entity', 'settings', fns 'sulfur-ore', val = {}},
})

