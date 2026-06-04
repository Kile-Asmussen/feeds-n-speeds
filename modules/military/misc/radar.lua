--! data: changed recipe for radars
local fns = require 'fns'
local inputs = fns.gadgets.throughputs

data.raw.technology.radar.prerequisites = { 'lamp' }

fns.table.merge(data.raw.recipe.radar, {
  ingredients = inputs{
    ['small-lamp'] = 1,
    ['copper-cable'] = 8,
    ['iron-stick'] = 8,
    ['iron-chest'] = 1,
    ['iron-gear-wheel'] = 5,
    ['electronic-circuit'] = 5,
  }
})