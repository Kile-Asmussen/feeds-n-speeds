require 'prelude'

-- TODO: split

local recipes = data.raw.recipe


turrets['gun-turret'].max_health = 800

turrets['rocket-turret'].max_health = 1000
turrets['rocket-turret'].attack_parameters.cooldown = 40
turrets['rocket-turret'].attack_parameters.min_range = 15
turrets['rocket-turret'].attack_parameters.range = 40
turrets['rocket-turret'].automated_ammo_count = 20
turrets['rocket-turret'].inventory_size = 2

turrets['railgun-turret'].attack_parameters.range = 50

turrets['railgun-turret'].max_health = 800

data.raw['electric-turret']['laser-turret'].max_health = 600

data.raw['fluid-turret']['flamethrower-turret'].attack_parameters.fluids = {
    {
        type='crude-oil',
        damage_modifier=0.5
    },
    {
        type='heavy-oil',
        damage_modifier=1.0
    },
    {
        type='light-oil',
        damage_modifier=0.9
    },
    { type=fns'napalm', damage_modifier = 1.35 }
}

fns_locale_key('modifier-description', 'shotgun-turret-attack-bonus')
fns_locale_key('modifier-description', 'cannon-turret-attack-bonus')

for i = 2, 7 do
    local ppd = data.raw.technology['physical-projectile-damage-' .. i]
    
    local turret = { type='turret-attack', turret_id=fns 'shotgun-turret', modifier = 0.15}

    table.insert(ppd.effects, turret)

    if i >= 5 then
        local big_turret = { type='turret-attack', turret_id=fns 'cannon-turret', modifier = 0.4}

    end
end

for n, ammo in pairs(data.raw.ammo) do
    if ammo.ammo_category == 'shotgun-shell' then 
        local proj = table.search(ammo.ammo_type, { type = 'projectile' })

        proj = data.raw.projectile[proj.projectile]

        proj.force_condition = 'not-same'

        proj.action.action_delivery.target_effects.apply_damage_to_trees = true
    end
end