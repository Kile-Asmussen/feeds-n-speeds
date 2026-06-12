--! data: balance changes to rocket weaponry
local fns = require 'fns'
local table = fns.table
local rocket = data.raw.projectile.rocket 
local find = fns.table.ifind
local match = fns.table.match

rocket.acceleration = 0.02
local eff = rocket.action.action_delivery.target_effects
find(eff, match{type='damage'}).damage.amount = 250


local ex = data.raw.projectile['explosive-rocket']
ex.acceleration = 0.02

local ex_eff = data.raw.projectile['explosive-rocket']
    .action.action_delivery.target_effects

find(ex_eff, match{type='damage'}).damage.amount = 100
local nest = find(ex_eff, match{type='nested-result'})

local nest_eff = nest.action.action_delivery.target_effects

find(nest_eff, match{type='damage'}).damage.amount = 250

-- TODO: make slowdown capsules better