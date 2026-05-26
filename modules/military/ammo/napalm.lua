
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
    auto_unlocked_by = 'flamethrower',
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
        tint = { 1, 0.5, 0.5 }
    }
}

data.raw.recipe['flamethrower-ammo'].category = 'crafting-with-fluid'
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


data:extend{
    napalm,
    napalm_recipe,
    napalm_ammo,
    napalm_steam,
    napalm_ammo_recipe,
    tank_napalm_steam
}