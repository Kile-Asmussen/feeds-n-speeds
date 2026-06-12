--! data: changed recipe for radars
local fns = require 'fns'
local inputs = fns.gadgets.throughputs

data.raw.technology.radar.prerequisites = { 'lamp' }

fns.table.merge(data.raw.recipe.radar, {
  ingredients = inputs{
    ['small-lamp'] = 1,
    ['iron-stick'] = 8,
    ['electric-engine-unit'] = 1,
    ['electronic-circuit'] = 3,
  }
})