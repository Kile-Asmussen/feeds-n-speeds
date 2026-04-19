require 'prelude'

local name = fns 'sulfur-ore'

return {
    type = 'autoplace-control',
    name = name,
    localised_name = {'', '[entity=' .. name .. '] ', {'entity-name.' .. name}},
    category = 'resource',
    richness = true,
    order = 'a-g',
}
