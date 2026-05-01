require 'prelude'
local debuglib = require 'debuglib'

local ushell = table.clone(data.raw.ammo['piercing-shotgun-shell'])
local ushell_proj = table.clone(data.raw.projectile['piercing-shotgun-pellet'])
local ushell_recipe = table.clone(data.raw.recipe['uranium-rounds-magazine'])

ushell_proj.name = fns 'uranium-shotgun-pellet'
ushell_proj.action.action_delivery.target_effects.damage.amount = 24

ushell.name = fns 'uranium-shotgun-shell'

ushell_recipe.name = ushell.name
ushell_recipe.ingredients[1].name = 'piercing-shotgun-shell'
ushell_recipe.results[1].name = ushell.name



ushell.icon = nil
ushell.icons = {
    {
        icon = data.raw.ammo['piercing-shotgun-shell'].icon,
        icon_size = 64,
        scale = 0.5,
        tint = { 0.3, 1, 0.3 },
    }
}

if ushell.ammo_type.action[1].repeat_count then
    ushell.ammo_type.action[1].action_delivery.projectile = ushell_proj.name
else
    ushell.ammo_type.action[2].action_delivery.projectile = ushell_proj.name
end

local napalm = table.clone(data.raw.fluid['light-oil'])
napalm.name = fns 'napalm'
napalm.base_color = { 0.77, 0.33, 0 }
napalm.flow_color = { 0.77, 0, 0.3 }
napalm.icons = {
    {
        icon = napalm.icon,
        icon_size = 64,
        scale = 0.5,
        tint = { 1, 0.3, 0.3 }
    },
    {
        icon = data.raw.item['plastic-bar'].icon,
        float=true,
        icon_size = 64,
        scale = 0.125
    },
}
napalm.icon = nil

local napalm_recipe = {
    type = 'recipe',
    name = fns 'napalm',
    category = 'chemistry',
    energy_required = 1,
    ingredients = {
        { type='fluid', name='light-oil', amount=50 },
        { type='item', name='plastic-bar', amount=2 },
    },
    results = {
        { type='fluid', name=fns 'napalm', amount=50 }
    }
}

local flamer = table.clone(data.raw.ammo['flamethrower-ammo'])
flamer.name = fns 'flamethrower-ammo'
flamer.magazine_size = 150

local flamer_recipe = table.clone(data.raw.recipe['flamethrower-ammo'])
flamer_recipe.localised_name = {"", { "item-name.flamethrower-ammo" }}
flamer_recipe.localised_description = {"", { "item-description.flamethrower-ammo" }}
flamer_recipe.name = fns 'flamethrower-ammo'
flamer_recipe.results = {
    { type='item', name= fns 'flamethrower-ammo', amount=1}
}
flamer_recipe.ingredients = {
    { type='fluid', name=fns'napalm', amount=100 },
    { type='item', name='barrel', amount=1 },
}

local flamer_stream = table.clone(data.raw.stream['handheld-flamethrower-fire-stream'])

flamer_stream.name = fns(flamer_stream.name)
local area = 1
local direct = 2
if flamer_stream.action[1].type ~= 'area' then
    area = 2
    direct = 1
end
flamer_stream.action[area].radius = 3.5

local damage = 2
if flamer_stream.action[area].action_delivery.target_effects[damage].type ~= 'damage' then
    damage = 1
end
flamer_stream.action[area].action_delivery.target_effects[damage].damage.amount = 5

flamer_stream.action[direct].action_delivery.target_effects[1].initial_ground_flame_count = 4

local tank_flamer_stream = table.clone(data.raw.stream['tank-flamethrower-fire-stream'])
tank_flamer_stream.name = fns(tank_flamer_stream.name)
tank_flamer_stream.action[1].action_delivery.target_effects[1].damage.amount=15

if flamer.ammo_type[1].action.action_delivery.stream:match('handheld') then
    flamer.ammo_type[1].action.action_delivery.stream = flamer_stream.name
    flamer.ammo_type[2].action.action_delivery.stream = tank_flamer_stream.name
else
    flamer.ammo_type[1].action.action_delivery.stream = tank_flamer_stream.name
    flamer.ammo_type[2].action.action_delivery.stream = flamer_stream.name
end

return {
    ushell,
    ushell_proj,
    ushell_recipe,
    napalm,
    napalm_recipe,
    flamer,
    flamer_stream,
    flamer_recipe,
    tank_flamer_stream
}