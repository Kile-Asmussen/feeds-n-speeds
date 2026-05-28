local fns = require 'fns'

local merge = fns.table.merge

merge(data.raw.recipe, {
    [{
        'transport-belt',
        'inserter',
        'lab'
    }] = merge{ auto_unlocked_by = fns 'lab-tech' },
    [{
        'iron-stick',
        'steel-plate',
        'iron-gear-wheel',
        'iron-chest'
    }] = merge{ auto_unlocked_by = 'steel-processing' },

    ['burner-inserter'] = merge{auto_unlocked_by = 'steam-power'},
})