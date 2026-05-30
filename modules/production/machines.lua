-- data: change some properties of certain assembly machines

local fns = require 'fns'

local merge = table.merge

merge(data.raw['assembling-machine'], {
    __rec = true,
    ['assembling-machine-1'] = { auto_require_pavement = 'stone-path' }
    ['assembling-machine-2'] = {
        auto_require_pavement = 'concrete',
        crafting_speed = 1.0
    },
    ['assembling-machine-3'] = merge{
        auto_require_pavement = 'refined-hazard-concrete',
        crafting_speed = 1.5,
        fluid_boxes = merge{
            [1] = merge{
                production_type = 'input',
                pipe_connections = {
                    { direction = defines.direction.east, flow_direction = 'input-output', position = {1, 0} },
                    { direction = defines.direction.west, flow_direction = 'input-output', position = {-1, 0} },
                }
            }
        }
    }
})