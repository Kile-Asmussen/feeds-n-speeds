
local fns = require 'fns'

local merge = table.merge

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
    },
    ['burner-inserter'] = merge{
        chases_belt_items = false,
        rotation_speed = 0.025,
        rotation_speed = 0.015,
        burner_leech = true
    }
})