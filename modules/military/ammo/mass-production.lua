
local tools = require 'gadgets'

local function make_new_ammo_recipe(name, amount, ingredients)
    local ammo = table.clone(data.raw.recipe[name])
    ammo.name = fns(name .. '-mass-production')
    ammo.localised_name = { "item-name." .. name }
    ammo.localised_description = { fns_locale_key('recipe-description', 'weapon-mass-production') }
    ammo.category = 'crafting-with-fluid'
    ammo.unlocked_by = 'military-4'
    ammo.energy_required = 2
    ammo.enabled = false
    ammo.ingredients = ingredients
    ammo.results = {
        { type='item', name=name, amount=amount }
    }
    ammo.icons = tools.icons({icon =  (data.raw.ammo[name] or data.raw.capsule[name]).icon}, { icon = data.raw.item['explosives'].icon })
    return ammo
end

data:extend{
    make_new_ammo_recipe('firearm-magazine', 10, {
        { type='item', name='explosives', amount=1 },
        { type='fluid', name='petroleum-gas', amount=20 },
        { type='item', name='iron-plate', amount=5 },
        { type='item', name='copper-plate', amount=5 },
    }),
    make_new_ammo_recipe('piercing-rounds-magazine', 10, {
        { type='item', name='explosives', amount=1 },
        { type='fluid', name='petroleum-gas', amount=20 },
        { type='item', name='steel-plate', amount=2 },
        { type='item', name='firearm-magazine', amount=10 },
    }),
    make_new_ammo_recipe('shotgun-shell', 10, {
        { type='item', name='explosives', amount=1 },
        { type='fluid', name='petroleum-gas', amount=30 },
        { type='item', name='iron-plate', amount=4 },
        { type='item', name='copper-plate', amount=6 },
    }),
    make_new_ammo_recipe('piercing-shotgun-shell', 10, {
        { type='item', name='explosives', amount=1 },
        { type='fluid', name='petroleum-gas', amount=30 },
        { type='item', name='steel-plate', amount=2 },
        { type='item', name='shotgun-shell', amount=10 },
    }),
    make_new_ammo_recipe('grenade', 5, {
        { type='item', name='explosives', amount=2 },
        { type='fluid', name='petroleum-gas', amount=30 },
        { type='item', name='steel-plate', amount=5 },
    })
}

