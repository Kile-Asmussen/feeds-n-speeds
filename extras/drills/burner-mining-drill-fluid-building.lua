require 'prelude'

-- Copy burner mining drill and add fluid input on south side (opposite output)
local base = data.raw['mining-drill']['burner-mining-drill']

local drill = table.clone(base)

drill.name = fns 'burner-mining-drill-fluid'
drill.minable.result = fns 'burner-mining-drill-fluid'

-- Add fluid input on south side (opposite the output chute which is north)
-- Note: defines.direction is runtime-only; use numeric direction (4 = south)
drill.input_fluid_box = {
    volume = 200,
    pipe_connections = {
        {
            direction = 4,  -- south
            position = {0, 0.5},
        },
    },
    pipe_covers = pipecoverspictures(),
}

return drill
