
local small = table.clone(data.raw.radar.radar)

small.name = fns 'small-radar'

local function downscale(v, k)
  if
    type(v) == 'table' and #v == 2
    and type(v[1]) == 'number' and type(v[2]) == 'number'
  then
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

small.max_health = 150
small.minable.result = small.name
small.icon = nil
small.icons = {
    { icon = '__base__/graphics/icons/radar.png', icon_size = 64 },
    {
      icon = '__base__/graphics/icons/arrows/down-arrow.png',
      icon_size = 64,
      scale = 0.25,
      shift = { -8, 8 },
      tint = { r = 0.2, g = 1, b = 0.2 },
    },
}

local item = table.clone(data.raw.item.radar)

item.name = small.name
item.place_result = small.name
item.icon = nil
item.icons = table.clone(small.icons)

local recipe = table.clone(data.raw.recipe.radar)

recipe.name = item.name
recipe.results[1].name = item.name
recipe.ingredients = {
  { type='item', amount=5, name='iron-plate' },
  { type='item', amount=4, name='iron-gear-wheel' },
  { type='item', amount=5, name='electronic-circuit' },
}
recipe.energy_required = 3.0

local remnants = table.clone(data.raw.corpse['radar-remnants'])
remnants.name = fns 'small-radar-remnants'
table.traverse(remnants, downscale)

local explosion = table.clone(data.raw.explosion['radar-explosion'])
explosion.name = fns 'small-radar-explosion'
table.traverse(explosion, downscale)

table.replace({ remnants.localised_name, explosion.localised_name }, "entity-name.radar", fns_locale_key("entity-name", "small-radar"))
table.replace({ remnants.localised_description, explosion.localised_description }, "entity-name.radar", fns_locale_key("entity-description", "small-radar"))

small.explosion = explosion.name
small.corpse = remnants.name

table.insert(data.raw.technology.radar.effects, {
    type = 'unlock-recipe',
    recipe = fns 'small-radar',
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