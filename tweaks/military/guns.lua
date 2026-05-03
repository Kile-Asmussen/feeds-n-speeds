require 'prelude'

local utilities = require 'extras.utilities'

local smg = table.clone(data.raw.recipe['submachine-gun'])
local shotty = table.clone(data.raw.recipe['combat-shotgun'])

smg.name = fns 'submachine-gun-plastic-stock'
shotty.name = fns 'combat-shotgun-plastic-stock'

smg.icon = data.raw.gun['submachine-gun'].icon
shotty.icon = data.raw.gun['combat-shotgun'].icon

smg.localised_name = {"", {"item-name.submachine-gun"}}
smg.localised_description = {"", {fns_locale_key("recipe-description", "plastic-furniture")}}

shotty.localised_name = {"", {"item-name.combat-shotgun"}}
shotty.localised_description = {"", {fns_locale_key("recipe-description", "plastic-furniture")}}

utilities.iconify(smg, data.raw.item['plastic-bar'].icon)
utilities.iconify(shotty, data.raw.item['plastic-bar'].icon)

return {
    smg,
    shotty
}