require 'prelude'



return {
  circuit_connector = {
    points = {
      shadow = {
        green = {
          1.021875,
          0.846875
        },
        red = {
          1.209375,
          0.846875
        }
      },
      wire = {
        green = {
          0.75625,
          0.721875
        },
        red = {
          0.6937,
          0.503125
        }
      }
    },
    sprites = {
      blue_led_light_offset = {
        0.44375,
        0.753125
      },
      connector_main = {
        filename = '__base__/graphics/entity/circuit-connector/ccm-universal-04a-base-sequence.png',
        height = 50,
        priority = 'low',
        scale = 0.5,
        shift = {
          0.44375,
          0.503125
        },
        width = 52,
        x = 104,
        y = 150
      },
      connector_shadow = {
        draw_as_shadow = true,
        filename = '__base__/graphics/entity/circuit-connector/ccm-universal-04b-base-shadow-sequence.png',
        height = 46,
        priority = 'low',
        scale = 0.5,
        shift = {
          0.6625,
          0.6125
        },
        width = 60,
        x = 120,
        y = 138
      },
      led_blue = {
        draw_as_glow = true,
        filename = '__base__/graphics/entity/circuit-connector/ccm-universal-04e-blue-LED-on-sequence.png',
        height = 60,
        priority = 'low',
        scale = 0.5,
        shift = {
          0.44375,
          0.471875
        },
        width = 60,
        x = 120,
        y = 180
      },
      led_blue_off = {
        filename = '__base__/graphics/entity/circuit-connector/ccm-universal-04f-blue-LED-off-sequence.png',
        height = 44,
        priority = 'low',
        scale = 0.5,
        shift = {
          0.44375,
          0.471875
        },
        width = 46,
        x = 92,
        y = 132
      },
      led_green = {
        draw_as_glow = true,
        filename = '__base__/graphics/entity/circuit-connector/ccm-universal-04h-green-LED-sequence.png',
        height = 46,
        priority = 'low',
        scale = 0.5,
        shift = {
          0.44375,
          0.471875
        },
        width = 48,
        x = 96,
        y = 138
      },
      led_light = {
        intensity = 0,
        size = 0.9
      },
      led_red = {
        draw_as_glow = true,
        filename = '__base__/graphics/entity/circuit-connector/ccm-universal-04i-red-LED-sequence.png',
        height = 46,
        priority = 'low',
        scale = 0.5,
        shift = {
          0.44375,
          0.471875
        },
        width = 48,
        x = 96,
        y = 138
      },
      red_green_led_light_offset = {
        0.09375,
        0.359375
      },
      wire_pins = {
        filename = '__base__/graphics/entity/circuit-connector/ccm-universal-04c-wire-sequence.png',
        height = 58,
        priority = 'low',
        scale = 0.5,
        shift = {
          0.44375,
          0.503125
        },
        width = 62,
        x = 124,
        y = 174
      },
      wire_pins_shadow = {
        draw_as_shadow = true,
        filename = '__base__/graphics/entity/circuit-connector/ccm-universal-04d-wire-shadow-sequence.png',
        height = 54,
        priority = 'low',
        scale = 0.5,
        shift = {
          0.740625,
          0.64375
        },
        width = 68,
        x = 136,
        y = 162
      }
    }
  },
  circuit_wire_max_distance = 9,
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
    'player-creation',
    'get-by-unit-number'
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
