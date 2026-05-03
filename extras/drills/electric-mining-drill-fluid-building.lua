require 'prelude'

-- Copy electric mining drill (keeps the fluid input)
local base = data.raw['mining-drill']['electric-mining-drill']

local drill = table.clone(base)

drill.name = fns 'electric-mining-drill-fluid'
drill.minable.result = fns 'electric-mining-drill-fluid'

drill.localised_description = {"", {fns_locale_key("entity-description", "lubricated-drilling")} }

-- input_fluid_box is inherited from the clone

return drill
