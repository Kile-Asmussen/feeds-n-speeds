
local fns = require 'fns'

local merge = table.merge
local assign = table.assign

local am1 = data.raw['assembling-machine']['assembling-machine-1']
local am2 = data.raw['assembling-machine']['assembling-machine-2']

merge(data.raw['assembling-machine'], {
    ['assembling-machine-2'] = merge{ crafting_speed = 1.0 },
    ['assembling-machine-3'] = merge{
        crafting_speed = 1.5,
        fluid_boxes = merge{
            [1] = merge{
                production_type = 'input',
                pipe_connections = {
                    { direction = defines.east, flow_direction = 'input-output', position = {1, 0} },
                    { direction = defines.west, flow_direction = 'input-output', position = {-1, 0} },
                }
            }
        }
    }
})

merge(data.raw.inserter, {
    ['inserter'] = merge{
        extension_speed = 0.05,
        rotation_speed = 0.03,
        filter_slots = 4,
        chases_belt_items = false
    },
    ['long-handed-inserter'] = merge{
        extension_speed = 0.1,
        rotation_speed = 0.03,
        filter_slots = 4,
        chases_belt_items = false
    },
    [{
        'fast-inserter',
        'bulk-inserter',
        'stack-inserter',
    }] = merge{
        rotation_speed = 0.05,
        extension_speed = 0.1,
        filter_slots = 4,
        chases_belt_items = false
    }
})