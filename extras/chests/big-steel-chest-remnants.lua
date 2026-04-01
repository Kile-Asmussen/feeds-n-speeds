return {
  animation = {
    direction_count = 1,
    filename = '__base__/graphics/entity/steel-chest/remnants/steel-chest-remnants.png',
    height = 88,
    line_length = 1,
    scale = 1,
    shift = {
      0.46875 * 2,
      -0.03125 * 2
    },
    width = 150
  },
  expires = false,
  final_render_layer = 'remnants',
  flags = {
    'placeable-neutral',
    'building-direction-8-way',
    'not-on-map'
  },
  hidden_in_factoriopedia = true,
  icon = '__base__/graphics/icons/steel-chest.png',
  localised_name = {
    'remnant-name',
    {
      'entity-name.big-steel-chest'
    }
  },
  name = 'big-steel-chest-remnants',
  order = 'a-c-a',
  remove_on_tile_placement = false,
  selectable_in_game = false,
  selection_box = {
    { -1, -1 },
    { 1, 1 }
  },
  subgroup = 'storage-remnants',
  tile_height = 2,
  tile_width = 2,
  time_before_removed = 54000,
  type = 'corpse'
}