require 'prelude'

local name = fns 'electroboiler'

-- Clone vanilla boiler and convert to electric energy source
local base = data.raw.boiler.boiler
local boiler = table.clone(base)

boiler.name = name
boiler.minable.result = name

-- Replace burner energy source with electric
boiler.energy_source = {
    type = 'electric',
    usage_priority = 'secondary-input',
    emissions_per_minute = { pollution = 0 },
}

-- Keep same energy consumption as vanilla boiler (1.8MW)
boiler.energy_consumption = '1.8MW'

-- Put in same fast-replace group as regular boiler
boiler.fast_replaceable_group = 'boiler'

return boiler
