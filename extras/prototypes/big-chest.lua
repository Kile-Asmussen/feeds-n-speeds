{
    type = "container",
    name = "big-chest",
    icon = "__FeedsNSpeeds__/graphics/big-chest-icon.png",
    icon_size = 32,
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 0.2, result = "big-chest"},
    inventory_size = 80,
	max_health = 700,
    corpse = "medium-remnants",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    vehicle_impact_sound =  { filename = "__base__/sound/car-metal-impact.ogg", volume = 0.75 },	
    resistances = {{ type = "fire", percent = 90 }, { type = "impact", percent = 60 }},
    collision_box = {{-0.70, -0.70}, {0.70, 0.70}},
    selection_box = {{-1.0, -1.0}, {1.0, 1.0}},
    fast_replaceable_group = "container",
	  scale_info_icons = 1,
--	circuit_wire_connection_point = { shadow = { red = {2.52, 0.65}, green = {2.01, 0.65}}, wire = { red = {2.22, 0.32}, green = {1.71, 0.32}}},
    picture =
    {
      layers =
      {
        {
          filename = "__base__/graphics/entity/steel-chest/steel-chest.png",
          priority = "extra-high",
          width = 32,
          height = 40,
          shift = util.by_pixel(0, -1),
          scale = 2,
          hr_version =
          {
            filename = "__FeedsNSpeeds__/graphics/big-chest/hr-building.png",
            priority = "extra-high",
            width = 64,
            height = 80,
            shift = { },
            scale = 1
          }
        },
        {
          filename = "__2x2-Chest__/graphics/entity/2x2-chest-shadow.png",
          priority = "extra-high",
          width = 56,
          height = 22,
          shift = util.by_pixel(12, 15),
          draw_as_shadow = true,
		  scale = 2,
          hr_version =
          {
            filename = "__2x2-Chest__/graphics/entity/hr-2x2-chest-shadow.png",
            priority = "extra-high",
            width = 110,
            height = 46,
            shift = util.by_pixel(24.5, 16),
            draw_as_shadow = true,
            scale = 1
          }
        }
      }
    },
	  circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
    circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
    circuit_wire_max_distance = default_circuit_wire_max_distance
  }