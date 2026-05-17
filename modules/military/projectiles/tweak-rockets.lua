
local rocket = data.raw.projectile.rocket 
rocket.acceleration = 0.02
local eff = rocket.action.action_delivery.target_effects
table.find_matching(eff, {type='damage'}).damage.amount = 250


local ex = data.raw.projectile['explosive-rocket']
ex.acceleration = 0.02

local ex_eff = data.raw.projectile['explosive-rocket']
    .action.action_delivery.target_effects

table.find_matching(ex_eff, {type='damage'}).damage.amount = 100
local nest = table.find_matching(ex_eff, {type='nested-result'})

local nest_eff = nest.action.action_delivery.target_effects

table.find_matching(nest_eff, {type='damage'}).damage.amount = 250

-- TODO: make slowdown capsules better