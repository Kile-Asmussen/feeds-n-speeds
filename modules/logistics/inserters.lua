--! data: tweaks to inserter speeds
local fns = require 'fns'
local table = fns.table

local merge = table.merge

merge(data.raw.inserter, {
    ['inserter'] = merge{
        extension_speed = 0.05,
        rotation_speed = 0.03,
        filter_slots = 4,
        chases_belt_items = false
        allow_burner_leech = true
    },
    ['long-handed-inserter'] = merge{
        extension_speed = 0.1,
        rotation_speed = 0.03,
        filter_slots = 4,
        chases_belt_items = false
        allow_burner_leech = true
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
        allow_burner_leech = true
    },
    ['burner-inserter'] = merge{
        chases_belt_items = false,
        filter_slots = 1,
        rotation_speed = 0.015,
        allow_burner_leech = true
    }
})