
-- if true then return end

local gadgets = require 'gadgets'
local inputs = gadgets.throughputs
local outputs = gadgets.throughputs

data.raw.technology.radar.prerequisites = { 'lamp' }

data.raw.recipe.radar.ingredients = inputs{
  ['small-lamp'] = 1,
  ['copper-cable'] = 8,
  ['iron-stick'] = 8,
  ['iron-chest'] = 1,
  ['iron-gear-wheel'] = 5,
  ['electronic-circuit'] = 5,
}
