
local military = require('namespace')('military')

local set = table.intoset

military.data = set{
    '.ammo.mass-production',
    '.ammo.napalm',
    ['.ammo.tweak-recipes'] = -1,
    '.ammo.uranium-buckshot',

    '.guns.tweak-attacks',
    ['.guns.tweak-recipes'] = -1,
    ['.guns.plastics'] = set{ '.guns.tweak-recipes' },

    '.misc.radar',
    '.misc.concrete-walling',


    '.projectiles.tweak-rockets',
    '.projectiles.cliffsplosives',

    '.tech.tree',

    '.turrets.cannon',
    '.turrets.shotgun',
    ['.turrets.tweak-attacks'] = -1,
    ['.turrets.tweak-recipes'] = -1,

}

return military:seal()