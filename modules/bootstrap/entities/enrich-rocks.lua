
local gadgets = require 'gadgets'
local outputs = gadgets.throughputs

table.append(
    data.raw['simple-entity']['huge-rock'].minable.results,
    outputs{ ['iron-ore'] = { 19, 25 }, ['copper-ore'] = { 5, 8 }, }
)

table.insert(
    data.raw['simple-entity']['big-sand-rock'].minable.results,
    outputs{ ['iron-ore'] = { 5, 10 }, ['copper-ore'] = { 1, 4 }, }
)