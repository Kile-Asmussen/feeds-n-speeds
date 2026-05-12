require 'prelude'

local military = namespace 'military'

military.data = asset{
    '.ammo.tweak-recipes',
    '.ammo.mass-production',

    '.projectiles.tweak-rockets',
    '.tech.tree',

    '.turrets.cannon',
    '.turrets.shotgun',
    '.turrets.tweaks-attacks',
    '.turrets.tweaks-recipes',

    '.guns.tweak-attacks',
    '.guns.tweak-recipes',

    '.entities.small-radar',

    ['.guns.plastics'] = asset{ '.guns.misc-tweaks' },
}

return military:seal()