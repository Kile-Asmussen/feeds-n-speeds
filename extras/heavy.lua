require 'prelude'

local heavy_weapons = namespace 'extras.heavy'

heavy_weapons.enabled = true

function heavy_weapons.data()

    data:extend( require 'extras.heavy.turret' )
    data:extend( require 'extras.heavy.big-turret' )

    if enabled('tweaks.military') then
        data:extend( require 'extras.heavy.ammo' )
    end
end

function heavy_weapons.data2()

    if enabled('tweaks.military') then
        table.insert(data.raw.technology['uranium-ammo'].effects,
        {type='unlock-recipe', recipe=fns 'uranium-shotgun-shell'})
    end

    table.insert(data.raw.technology.automobilism.prerequisites, 'gun-turret')

    table.remove_matching(data.raw.technology.tank.effects, { name=("shell$"):pattern() })
    data.raw.technology.tank.prerequisites = { fns 'cannon-turret-tech', 'automobilism', 'flammables' }

    data.raw.recipe['flamethrower-ammo'].category = 'crafting-with-fluid'

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

    local debuglib = require 'debuglib'

    for n, ammo in pairs(data.raw.ammo) do
        if ammo.ammo_category == 'shotgun-shell' then 
            local proj = table.search(ammo.ammo_type, { type = 'projectile' })

            proj = data.raw.projectile[proj.projectile]

            proj.force_condition = 'not-same'

            proj.action.action_delivery.target_effects.apply_damage_to_trees = true
        end
    end
end

return seal_namespace(heavy_weapons)