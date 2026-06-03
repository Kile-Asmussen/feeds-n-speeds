--! data: change the burner miner so it can mine ores that requires fluid
local fns = require 'fns'
local puts = fns.gadgets.throughputs
local merge = fns.table.merge
local icon = fns.gadgets.icon
local floating_icon = fns.gadgets.floating_icon

data.raw.recipe['burner-mining-drill'].auto_unlocked_by = 'steam-power'

merge(data.raw['mining-drill']['burner-mining-drill'], {
    input_fluid_box = {
        volume = 50,
        filter = 'water',
        production_type = 'input',
        pipe_connections = {
            {
                direction = defines.direction.north,
                flow_direction = 'input',
                position = {0.5, -0.5},
            },
        },
        pipe_covers = pipecoverspictures(),
    },

})