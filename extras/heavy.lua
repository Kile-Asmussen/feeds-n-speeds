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
end

return heavy_weapons:__seal()