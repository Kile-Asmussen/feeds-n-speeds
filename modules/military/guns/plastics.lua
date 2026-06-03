--! data: gun recipe variants using plastic instead of wood, since the guns are used in construction of turrets and wood is a scarce resource

local fns = require 'fns'
local table = fns.table

local icon = fns.gadgets.icon
local floating_icon = fns.gadgets.floating_icon
local inputs = fns.gadgets.throughputs

local plasticon = data.raw.item['plastic-bar'].icon

local guns = fns.table.merge({
    smg = table.deepcopy(data.raw.recipe['submachine-gun']),
    shotty = table.deepcopy(data.raw.recipe['combat-shotgun']),
}, {
    __rec = true,
    smg = {
        name = fns 'submachine-gun-plastic-stock',
        localised_name = {"item-name.submachine-gun"},
        localised_description = {fns.locale_key("recipe-description", "plastic-furniture")},
        auto_unlocked_by = "military-3",
        icons = {
            icon(data.raw.gun['submachine-gun'].icon, 'recipe'),
            floating_icon('bottomleft', plasticon),
        },
        ingredients = inputs{
            ['copper-plate'] = 2,
            ['iron-plate'] = 4,
            ['iron-gear-wheel'] = 4,
            ['steel-plate'] = 1,
            ['plastic-bar'] = 2,
        }
    },
    shotty = {
        name = fns 'combat-shotgun-plastic-stock',
        localised_name = {"item-name.combat-shotgun"},
        localised_description = {fns.locale_key("recipe-description", "plastic-furniture")},
        auto_unlocked_by = "military-3",
        icons = {
            icon(data.raw.gun['combat-shotgun'].icon, 'recipe'),
            floating_icon('bottomleft', plasticon),
        },
        ingredients = inputs{
            ['copper-plate'] = 4,
            ['iron-plate'] = 4,
            ['iron-gear-wheel'] = 4,
            ['plastic-bar'] = 2,
            ['steel-plate'] = 1,
        }
    }
})

data:extend{ guns.smg, guns.shotty }