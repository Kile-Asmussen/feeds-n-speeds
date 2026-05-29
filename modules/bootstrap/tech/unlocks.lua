local fns = require 'fns'

local merge = fns.table.merge

merge(data.raw.recipe, {
    __rec = true,
    [{
        'transport-belt',
        'inserter',
        'lab'
    }] = { auto_unlocked_by = fns 'lab-tech' },
    [{
        'iron-stick',
        'steel-plate',
        'iron-gear-wheel',
        'iron-chest'
    }] = { auto_unlocked_by = 'steel-processing' },

    ['burner-inserter'] = {auto_unlocked_by = 'steam-power'},
})