require 'prelude'

local military = namespace 'military'

military.data = asset{
    '.ammo.tweak-recipes',
    '.ammo.mass-production',

    '.projectiles.rockets',
    '.tech.tree',

    '.turrets.cannon',
    '.turrets.shotgun',
    '.turrets.misc-tweaks',

    '.guns.tweak-attacks',
    '.guns.tweak-recipes',

    ['.guns.plastics'] = asset{ '.guns.misc-tweaks' },
}

return military:seal()