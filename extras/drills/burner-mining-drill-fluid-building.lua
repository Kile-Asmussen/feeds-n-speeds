require 'prelude'

-- Copy burner mining drill and add fluid input on south side (opposite output)
local base = data.raw['mining-drill']['burner-mining-drill']

local drill = table.clone(base)

drill.name = fns 'burner-mining-drill-fluid'
drill.minable.result = fns 'burner-mining-drill-fluid'

drill.localised_description = {"", {fns_locale_key("entity-description", "lubricated-drilling")} }

-- Add fluid input on north side (same side as output chute, intentionally awkward)
-- Note: defines.direction is runtime-only; use numeric direction (0 = north)
-- Filter to steam only: usable for sulfur ore, not uranium (sulfuric acid)
drill.input_fluid_box = {
    volume = 50,
    filter = 'water',
    production_type = 'input',
    pipe_connections = {
        {
            direction = 0,  -- north
            flow_direction = 'input',
            position = {0.5, -0.5},
        },
    },
    pipe_covers = pipecoverspictures(),
}

return drill
