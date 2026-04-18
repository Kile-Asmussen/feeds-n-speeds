return {
  drop_sound = {
    aggregation = {
      max_count = 1,
      remove = true
    },
    filename = '__base__/sound/item/metal-chest-inventory-move.ogg',
    volume = 0.6
  },
  icons = {
    { icon = '__FeedsNSpeeds__/graphics/item/big-steel-hopper.png', icon_size = 64 },
    {
      icon = '__base__/graphics/icons/arrows/up-arrow.png',
      icon_size = 64,
      scale = 0.25,
      shift = { -8, 8 },
      tint = { r = 0.2, g = 1, b = 0.2 },
    },
  },
  inventory_move_sound = {
    aggregation = {
      max_count = 1,
      remove = true
    },
    filename = '__base__/sound/item/metal-chest-inventory-move.ogg',
    volume = 0.6
  },
  name = fns 'big-steel-hopper',
  localised_name = {"", {'entity-name.' .. fns 'big-steel-hopper'}},
  localised_description = {"", {'entity-description.' .. fns 'big-steel-hopper'}},
  order = 'a[items]-d[big-steel-chest]',
  pick_sound = {
    aggregation = {
      max_count = 1,
      remove = true
    },
    filename = '__base__/sound/item/metal-chest-inventory-pickup.ogg',
    volume = 0.6
  },
  place_result = fns 'big-steel-hopper',
  stack_size = 20,
  subgroup = 'storage',
  type = 'item'
}