require 'prelude'

local heavy_weapons = namespace 'extras.heavy'

heavy_weapons.enabled = true

function heavy_weapons.data()

    data:extend( require 'extras.heavy.turret' )
    data:extend( require 'extras.heavy.big-turret' )

    if enabled('tweaks.military') then
        data:extend( require 'extras.heavy.uranium-buckshot' )
        data:extend( require 'extras.heavy.napalm' )
    end
end

function heavy_weapons.data2()


    


end

return seal_namespace(heavy_weapons)