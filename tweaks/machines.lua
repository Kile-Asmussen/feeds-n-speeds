require 'prelude'

local machines = namespace 'tweaks.machines'
machines.enabled = true

function machines.data_updates()
    if not machines.enabled then return end

    machines.tweak_assemblers()
end

function machines.tweak_assemblers()
    local am3 = data.raw['assembling-machine']['assembling-machine-3']

    -- Replace the input fluid box with east-west through-flow connections
    am3.fluid_boxes[1].production_type = 'input-output'
    am3.fluid_boxes[1].pipe_connections = {
        {
            direction = 4,  -- east
            flow_direction = 'input-output',
            position = {1, 0},
        },
        {
            direction = 12,  -- west
            flow_direction = 'input-output',
            position = {-1, 0},
        },
    }
end

return machines:__seal()