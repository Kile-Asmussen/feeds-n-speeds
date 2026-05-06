require 'prelude'
local debuglib = require 'debuglib'

local ushell = table.clone(data.raw.ammo['piercing-shotgun-shell'])
local ushell_proj = table.clone(data.raw.projectile['piercing-shotgun-pellet'])
local ushell_recipe = table.clone(data.raw.recipe['uranium-rounds-magazine'])

ushell_proj.name = fns 'uranium-shotgun-pellet'
ushell_proj.action.action_delivery.target_effects.damage.amount = 16

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
        shift={ 0, 4 },
        tint = { 1, 1, 1, 0.5 },
        scale = 0.25
    },
}
napalm.icon = nil

local napalm_recipe = {
    type = 'recipe',
    name = fns 'napalm',
    category = 'chemistry',
    subgroup = 'ammo',
    energy_required = 1,
    enabled = false,
    ingredients = {
        { type='fluid', name='light-oil', amount=50 },
        { type='item', name='plastic-bar', amount=2 },
    },
    results = {
        { type='fluid', name=fns 'napalm', amount=50 }
    }
}

local napalm_ammo = table.clone(data.raw.ammo['flamethrower-ammo'])
napalm_ammo.name = fns 'flamethrower-ammo'
napalm_ammo.icons = {
    {
        icon=napalm_ammo.icon,
        icon_size = 64,
        scale = 0.5,
        tint = { 1, 0.8, 0.8 }
    }
}

local napalm_ammo_recipe = table.clone(data.raw.recipe['flamethrower-ammo'])
napalm_ammo_recipe.name = fns 'flamethrower-ammo'
napalm_ammo_recipe.results = {
    { type='item', name= fns 'flamethrower-ammo', amount=1}
}
napalm_ammo_recipe.ingredients = {
    { type='fluid', name=fns'napalm', amount=100 },
    { type='item', name='barrel', amount=1 },
}

local napalm_steam = table.clone(data.raw.stream['handheld-flamethrower-fire-stream'])

napalm_steam.name = fns(napalm_steam.name)
local area = 1
local direct = 2
if napalm_steam.action[1].type ~= 'area' then
    area = 2
    direct = 1
end
napalm_steam.action[area].radius = 3.5

local damage = 2
if napalm_steam.action[area].action_delivery.target_effects[damage].type ~= 'damage' then
    damage = 1
end
napalm_steam.action[area].action_delivery.target_effects[damage].damage.amount = 5

napalm_steam.action[direct].action_delivery.target_effects[1].initial_ground_flame_count = 4

local tank_napalm_steam = table.clone(data.raw.stream['tank-flamethrower-fire-stream'])
tank_napalm_steam.name = fns(tank_napalm_steam.name)
tank_napalm_steam.action[1].action_delivery.target_effects[1].damage.amount=15

if napalm_ammo.ammo_type[1].action.action_delivery.stream:match('handheld') then
    napalm_ammo.ammo_type[1].action.action_delivery.stream = napalm_steam.name
    napalm_ammo.ammo_type[2].action.action_delivery.stream = tank_napalm_steam.name
else
    napalm_ammo.ammo_type[1].action.action_delivery.stream = tank_napalm_steam.name
    napalm_ammo.ammo_type[2].action.action_delivery.stream = napalm_steam.name
end

local hidden = not enabled('tweaks.military')

local res = {
    ushell,
    ushell_proj,
    ushell_recipe,
    napalm,
    napalm_recipe,
    napalm_ammo,
    napalm_steam,
    napalm_ammo_recipe,
    tank_napalm_steam
}

for _, x in ipairs(res) do x.hidden = hidden end

return res