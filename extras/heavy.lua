require 'prelude'

local heavy_weapons = namespace 'extras.heavy'

heavy_weapons.enabled = true

function heavy_weapons.data()
    if not heavy_weapons.enabled then return end

    data:extend( require 'extras.heavy.turret' )

    if enabled('tweaks.military') then
        data:extend( require 'extras.heavy.ammo' )
    end
end

function heavy_weapons.data_updates()
    if not heavy_weapons.enabled then return end

    if enabled('tweaks.military') then
        table.insert(data.raw.technology['uranium-ammo'].effects,
        {type='unlock-recipe', recipe=fns 'uranium-shotgun-shell'})
    end

    for i = 2, 7 do
        local ppd = data.raw.technology['physical-projectile-damage-' .. i]
        
        local turret = table.clone(table.find_matching(ppd.effects, {type='turret-attack'}))

        turret.turret_id = fns 'shotgun-turret'
        turret.modifier = 0.15

        table.insert(ppd.effects, turret)
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

return heavy_weapons:__seal()