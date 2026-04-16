return {
  drop_sound = {
    aggregation = {
      max_count = 1,
      remove = true
    },
    filename = '__base__/sound/item/metal-chest-inventory-move.ogg',
    volume = 0.6
  },
  icon = '__FeedsNSpeeds__/graphics/smart-big-steel-chest.png',
  inventory_move_sound = {
    aggregation = {
      max_count = 1,
      remove = true
    },
    filename = '__base__/sound/item/metal-chest-inventory-move.ogg',
    volume = 0.6
  },
  name = fns 'smart-big-steel-chest',
  localised_name = {"", {'entity-name.' .. fns 'smart-big-steel-chest'}},
  localised_description = {"", {'entity-description.' .. fns 'smart-big-steel-chest'}},
  order = 'a[items]-e[big-steel-chest]',
  pick_sound = {
    aggregation = {
      max_count = 1,
      remove = true
    },
    filename = '__base__/sound/item/metal-chest-inventory-pickup.ogg',
    volume = 0.6
  },
  place_result = fns 'smart-big-steel-chest',
  stack_size = 20,
  subgroup = 'storage',
  type = 'item'
}