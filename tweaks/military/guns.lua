require 'prelude'

local utilities = require 'extras.utilities'

local smg = table.clone(data.raw.recipe['submachine-gun'])
local shotty = table.clone(data.raw.recipe['combat-shotgun'])

smg.name = fns 'submachine-gun-plastic-stock'
shotty.name = fns 'combat-shotgun-plastic-stock'

utilities.iconify(smg, data.raw.item['plastic-bar'].icon)
utilities.iconify(shotty, data.raw.item['plastic-bar'].icon)

return {
    smg,
    shotty
}