
local tools = require 'gadgets'

local smg = table.clone(data.raw.recipe['submachine-gun'])
local shotty = table.clone(data.raw.recipe['combat-shotgun'])

smg.name = fns 'submachine-gun-plastic-stock'
shotty.name = fns 'combat-shotgun-plastic-stock'

smg.icons = tools.icons({
    icon = data.raw.gun['submachine-gun'].icon
},{
    icon = data.raw.item['plastic-bar'].icon
})

shotty.icons = tools.icons({
    icon = data.raw.gun['combat-shotgun'].icon
},{
    icon = data.raw.item['plastic-bar'].icon,
})

smg.localised_name = {"item-name.submachine-gun"}
smg.localised_description = {fns_locale_key("recipe-description", "plastic-furniture")}

shotty.localised_name = {"item-name.combat-shotgun"}
shotty.localised_description = {fns_locale_key("recipe-description", "plastic-furniture")}

table.find_matching(smg.ingredients, {name='wood'}).name = 'plastic-bar'
table.find_matching(shotty.ingredients, {name='wood'}).name = 'plastic-bar'

prototype( smg, shotty )