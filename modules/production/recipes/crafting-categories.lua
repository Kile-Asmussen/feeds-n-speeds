
local fns = require 'fns'

local hand, org, press, elec, cryo, t3
    = fns 'hand-crafting'
    , fns 'advanced-crafting-organic'
    , fns 'advanced-pressing'
    , fns 'advanced-electronics'
    , fns 'advanced-crafting-cryogenics'
    , fns 'tier-3-crafting'

data:extend{
    { type='recipe-category', name=hand },
    { type='recipe-category', name=org },
    { type='recipe-category', name=press },
    { type='recipe-category', name=elec },
    { type='recipe-category', name=cryo },
    { type='recipe-category', name=t3 },
}


