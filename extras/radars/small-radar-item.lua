return {
  drop_sound = {
    aggregation = {
      max_count = 1,
      remove = true
    },
    filename = '__base__/sound/item/metal-large-inventory-move.ogg',
    volume = 0.7
  },
  icon = '__FeedsNSpeeds__/graphics/small-radar.png',
  inventory_move_sound = {
    aggregation = {
      max_count = 1,
      remove = true
    },
    filename = '__base__/sound/item/metal-large-inventory-move.ogg',
    volume = 0.7
  },
  localised_name = {"", {"entity-name." .. fns 'small-radar'}},
  localised_description = { "", {"entity-description." .. fns 'small-radar'} },
  name = fns 'small-radar',
  order = 'd[radar]-b[radar]',
  pick_sound = {
    aggregation = {
      max_count = 1,
      remove = true
    },
    filename = '__base__/sound/item/metal-large-inventory-pickup.ogg',
    volume = 0.8
  },
  place_result = fns 'small-radar',
  random_tint_color = {
    1,
    0.95,
    0.9,
    1
  },
  stack_size = 50,
  subgroup = 'defensive-structure',
  type = 'item'
}
