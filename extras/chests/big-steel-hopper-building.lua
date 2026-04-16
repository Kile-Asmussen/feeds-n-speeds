require 'prelude'



return {
  circuit_connector = nil,
  circuit_wire_max_distance = 0,
  close_sound = {
    filename = '__base__/sound/metallic-chest-close.ogg',
    volume = 0.3
  },
  collision_box = {
    {
      -0.35 * 2,
      -0.35 * 2
    },
    {
      0.35 * 2,
      0.35 * 2
    }
  },
  corpse = fns 'big-steel-chest-remnants',
  damaged_trigger_effect = {
    damage_type_filters = 'fire',
    entity_name = 'spark-explosion',
    offset_deviation = {
      {
        -0.5 * 2,
        -0.5 * 2
      },
      {
        0.5 * 2,
        0.5 * 2
      }
    },
    offsets = {
      {
        0,
        1 * 2
      }
    },
    type = 'create-entity'
  },
  dying_explosion = fns 'big-steel-chest-explosion',
  fast_replaceable_group = 'container',
  flags = {
    'placeable-neutral',
    'player-creation'
  },
  icon = '__base__/graphics/icons/steel-chest.png',
  icon_draw_specification = {
    scale = 0.7
  },
  impact_category = 'metal',
  inventory_size = 48 * 2,
  max_health = 350 * 2,
  minable = {
    mining_time = 0.2,
    result = fns 'big-steel-hopper'
  },
  name = fns 'big-steel-hopper',
  open_sound = {
    filename = '__base__/sound/metallic-chest-open.ogg',
    volume = 0.43
  },
  picture = {
    layers = {
      {
        filename = '__FeedsNSpeeds__/graphics/entity/hopper.png',
        height = 80,
        priority = 'extra-high',
        scale = 0.5 * 2,
        shift = {
          -0.0078125 * 2,
          -0.015625 * 2
        },
        width = 64
      },
      {
        draw_as_shadow = true,
        filename = '__base__/graphics/entity/steel-chest/steel-chest-shadow.png',
        height = 46,
        priority = 'extra-high',
        scale = 0.5 * 2,
        shift = {
          0.3828125 * 2,
          0.25 * 2
        },
        width = 110
      }
    }
  },
  resistances = {
    {
      percent = 90,
      type = 'fire'
    },
    {
      percent = 60,
      type = 'impact'
    }
  },
  selection_box = {
    {
      -0.5 * 2,
      -0.5 * 2
    },
    {
      0.5 * 2,
      0.5 * 2
    }
  },
  surface_conditions = {
    {
      min = 0.1,
      property = 'gravity'
    }
  },
  type = 'proxy-container'
}
