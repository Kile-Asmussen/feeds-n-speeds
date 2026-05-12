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

    '.misc.small-radar',
    '.misc.concrete-walling',

    ['.guns.plastics'] = asset{ '.guns.misc-tweaks' },
}

return military:seal()