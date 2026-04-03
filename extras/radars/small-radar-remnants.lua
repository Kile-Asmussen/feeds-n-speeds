return {
  animation = {
    {
      direction_count = 1,
      filename = '__base__/graphics/entity/radar/remnants/radar-remnants.png',
      height = 212,
      line_length = 1,
      scale = 0.5 * (2/3),
      shift = {
        0.375,
        0.140625
      },
      width = 282,
      y = 0
    }
  },
  expires = false,
  final_render_layer = 'remnants',
  flags = {
    'placeable-neutral',
    'not-on-map'
  },
  hidden_in_factoriopedia = true,
  icon = '__base__/graphics/icons/radar.png',
  localised_name = { 'remnant-name', { 'entity-name.' .. fns 'small-radar' } },
  localised_description = { 'remnant-description', { 'entity-description.' .. fns 'small-radar' } },
  name = fns 'small-radar-remnants',
  order = 'a-g-b',
  remove_on_tile_placement = false,
  selectable_in_game = false,
  selection_box = {
    {
      -1.5 - 0.5,
      -1.5 - 0.5
    },
    {
      1.5 - 0.5,
      1.5 - 0.5
    }
  },
  subgroup = 'defensive-structure-remnants',
  tile_height = 2,
  tile_width = 2,
  time_before_removed = 54000,
  type = 'corpse'
}
