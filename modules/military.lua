
local military = require('namespace')('military')

local set = table.intoset

military.data = set{
    '.ammo.tweak-recipes',
    '.ammo.mass-production',

    '.projectiles.tweak-rockets',
    '.tech.tree',

    '.turrets.cannon',
    '.turrets.shotgun',
    '.turrets.tweak-attacks',
    '.turrets.tweak-recipes',

    '.guns.tweak-attacks',
    '.guns.tweak-recipes',

    '.misc.small-radar',
    '.misc.concrete-walling',

    ['.guns.plastics'] = set{ '.guns.tweak-recipes' },
}

return military:seal()