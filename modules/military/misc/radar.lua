
-- if true then return end

local gadgets = require 'gadgets'
local inputs = gadgets.throughputs
local outputs = gadgets.throughputs

data.raw.technology.radar.prerequisites = { 'lamp' }

data.raw.recipe.radar.ingredients = inputs{
  ['small-lamp'] = 2,
  ['copper-cable'] = 10,
  ['iron-stick'] = 8,
  ['steel-plate'] = 2,
  ['iron-gear-wheel'] = 5,
  ['electronic-circuit'] = 10,
}

local small = table.clone(data.raw.radar.radar)
local set = table.intoset

local downscale =
  gadgets.scale(
    2/3,
    set{ 'scale', 'volume', 'volume_multiplier' }, -- these fields
    true, -- all vectors
    nil -- stop at nothing
  )

table.traverse(small, downscale)

table.merge(small, {
  name = fns 'small-radar',
  max_health = 150,
  minable = table.merge{ result = fns 'small-radar' },
  icon = utils.null,
  auto_unlocked_by = 'radar',
  icons = {
    { icon = '__base__/graphics/icons/radar.png', icon_size = 64 },
    {
      icon = '__base__/graphics/icons/arrows/down-arrow.png',
      icon_size = 64,
      scale = 0.25,
      shift = { -8, 8 },
      tint = { r = 0.2, g = 1, b = 0.2 },
    },
  }
})

local item = table.clone(data.raw.item.radar)

table.merge(item, {
  name = small.name,
  place_result = small.name,
  icon = utils.null,
  icons = table.clone(small.icons),
})

local recipe = table.clone(data.raw.recipe.radar)

table.merge(recipe, {
  name = item.name,
  results = outputs{ [fns 'small-radar'] = 1 },
  ingredients = inputs{
    ['small-lamp'] = 1,
    ['copper-cable'] = 5,
    ['iron-stick'] = 4,
    ['steel-plate'] = 1,
    ['iron-gear-wheel'] = 3,
    ['electronic-circuit'] = 5,
  },
  icon = utils.null,
  icons = table.clone(small.icons),
})

local remnants = table.clone(data.raw.corpse['radar-remnants'])
remnants.name = fns 'small-radar-remnants'
table.traverse(remnants, downscale)

local explosion = table.clone(data.raw.explosion['radar-explosion'])
explosion.name = fns 'small-radar-explosion'
table.traverse(explosion, downscale)

table.replace({ remnants.localised_name, explosion.localised_name }, "entity-name.radar", fns.locale_key("entity-name", "small-radar"))

table.replace({ remnants.localised_description, explosion.localised_description }, "entity-description.radar", fns.locale_key("entity-description", "small-radar"))

table.merge(small, {
  explosion = explosion.name,
  corpse = remnants.name,
})

table.find_matching(data.raw.recipe['artillery-shell'].ingredients,
    { type='item', name = 'radar'}
).name = fns 'small-radar'

data:extend{
  small,
  item,
  recipe,
  explosion,
  remnants
}