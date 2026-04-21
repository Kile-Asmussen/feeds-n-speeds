return {
  drop_sound = {
    aggregation = {
      max_count = 1,
      remove = true
    },
    filename = '__base__/sound/item/metal-large-inventory-move.ogg',
    volume = 0.7
  },
  icons = {
    { icon = '__base__/graphics/icons/radar.png', icon_size = 64 },
    {
      icon = '__base__/graphics/icons/arrows/down-arrow.png',
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
    filename = '__base__/sound/item/metal-large-inventory-move.ogg',
    volume = 0.7
  },
  localised_name = {"", { fns("entity-name", 'small-radar')}},
  localised_description = { "", { fns("entity-description", 'small-radar')} },
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
