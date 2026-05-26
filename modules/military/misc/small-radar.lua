
local small = table.clone(data.raw.radar.radar)

local function downscale(v, k)
  if table.isvec(v) then
    table.vecmul(v, 2/3)
    return true
  elseif
    (k == 'scale' or k == 'volume' or k == 'volume_multiplier')
    and type(v) == 'number'
  then
    return v * (2/3), true
  end
end

table.traverse(small, downscale)

table.merge(small, {
  name = fns 'small-radar',
  max_health = 150,
  minable.result = fns 'small-radar',
  icon = functions.null,
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
  icon = functions.null,
  icons = table.clone(small.icons),
})

local recipe = table.clone(data.raw.recipe.radar)

table.merge(recipe, {
  name = item.name,
  recipe.results[1].name = item.name,
  ingredients = {
    { type='item', amount=5, name='iron-plate' },
    { type='item', amount=4, name='iron-gear-wheel' },
    { type='item', amount=5, name='electronic-circuit' },
  },
  energy_required = 3.0,
})

local remnants = table.clone(data.raw.corpse['radar-remnants'])
remnants.name = fns 'small-radar-remnants'
table.traverse(remnants, downscale)

local explosion = table.clone(data.raw.explosion['radar-explosion'])
explosion.name = fns 'small-radar-explosion'
table.traverse(explosion, downscale)

table.replace({ remnants.localised_name, explosion.localised_name }, "entity-name.radar", fns_locale_key("entity-name", "small-radar"))

table.replace({ remnants.localised_description, explosion.localised_description }, "entity-description.radar", fns_locale_key("entity-description", "small-radar"))

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