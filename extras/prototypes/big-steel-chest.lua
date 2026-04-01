{
    circuit_connector = 'SERPENT PLACEHOLDER',
    circuit_wire_max_distance = 9,
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    collision_box = {
        {
        -0.35,
        -0.35
        },
        {
        0.35,
        0.35
        }
    },
    corpse = 'medium-remnants',
    damaged_trigger_effect = {
        damage_type_filters = 'fire',
        entity_name = 'spark-explosion',
        offset_deviation = {
        {
            -0.5,
            -0.5
        },
        {
            0.5,
            0.5
        }
        },
        offsets = {
        {
            0,
            1
        }
        },
        type = 'create-entity'
    },
    dying_explosion = 'steel-chest-explosion',
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
    inventory_size = 48,
    max_health = 350,
    minable = {
        mining_time = 0.2,
        result = 'steel-chest'
    },
    name = 'steel-chest',
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
    picture = {
        layers = {
            {
                filename = '__base__/graphics/entity/steel-chest/steel-chest.png',
                height = 80,
                priority = 'extra-high',
                scale = 0.5,
                shift = {
                -0.0078125,
                -0.015625
                },
                width = 64
            },
            {
                draw_as_shadow = true,
                filename = '__base__/graphics/entity/steel-chest/steel-chest-shadow.png',
                height = 46,
                priority = 'extra-high',
                scale = 0.5,
                shift = {
                0.3828125,
                0.25
                },
                width = 110
            }
        }
    },
    resistances = {
        { percent = 90, type = 'fire' },
        { percent = 60, type = 'impact' }
    },
    selection_box = {
        { -0.5, -0.5 },
        { 0.5, 0.5 }
    },
    surface_conditions = {{
            min = 0.1,
            property = 'gravity'
    }},
    type = 'container'
}
