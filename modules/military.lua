require 'prelude'

local military = namespace 'military'

military.data = asset{
    '.ammo.misc-tweaks',
    '.ammo.mass-production',

    '.projectiles.rockets',
    '.tech.tree',

    '.turrets.cannon',
    '.turrets.shotgun',
    '.turrets.misc-tweaks',

    '.guns.misc-tweaks',

    ['.guns.plastics'] = asset{ '.guns.misc-tweaks' },
}

return military:seal()