
local iron_chest =  data.raw.container['iron-chest']
local tap = table.clone(data.raw.furnace['stone-furnace'])

tap.name=fns 'barrel-tapper'
tap.crafting_categories = { fns 'barrelling' }
tap.circuit_connector = nil
tap.collision_box = {
    { -0.5, -0.5 }, 
    { 0.5, 0.5 }, 
}
tap.selection_box = table.clone(tap.collision_box)
tap.crafting_speed = 0.2

tap.cant_insert_at_source_message_key = fns_locale_key('inventory-restriction', 'cant-be-barreled')
tap.custom_input_slot_tooltip_key = fns_locale_key('tooltip', 'barrel-tapper')

tap.corpse = iron_chest.corpse
tap.dying_explosion = iron_chest.dying_explosion
tap.impact_category = 'metal'

tap.vector_to_place_result = {
    -0.95, 0
}

tap.energy_source = {
    type='void',
}
tap.energy_usage = '5kW'
tap.next_upgrade = nil
tap.show_recipe_icon = false

tap.effects_receiver = {}

tap.graphics_set = {
    animation = table.clone(iron_chest.picture),
}
tap.graphics_set.animation.layers[1].tint = {0.6, 0.6, 0.6}
tap.graphics_set.animation.layers[1].scale = 0.6
tap.graphics_set.animation.layers[2].scale = 0.6

tap.close_sound = table.clone(data.raw['assembling-machine']['assembling-machine-1'].close_sound)
tap.open_sound = table.clone(data.raw['assembling-machine']['assembling-machine-1'].open_sound)

tap.fluid_boxes = {
    {
        volume = 500,
        production_type = 'input',
        pipe_connections = {
            {
                direction = defines.direction.north,
                flow_direction = 'input',
                position = {0, 0},
            },
        },
        pipe_covers = pipecoverspictures(),
        always_draw_covers = true,
    },
    {
        volume = 500,
        production_type = 'output',
        pipe_connections = {
            {
                direction = defines.direction.south,
                flow_direction = 'output',
                position = {0, 0},
            },
        },
        pipe_covers = pipecoverspictures(),
        always_draw_covers = true,
    }
}

tap.minable = {
    mining_time = 0.5,
    result = tap.name
}

tap.icon = nil
tap.icons = {
    {
        icon = iron_chest.icon,
        tint = { 0.5, 0.5, 0.5 },
        scale = 0.7,
    },
    {
        icon = data.raw.item.barrel.icon,
        scale = 0.5,
        float= true,
        shift = { 0.0, -4 },
    }
}

local tap_item = table.clone(data.raw.item[iron_chest.name])
tap_item.name = tap.name
tap_item.place_result = tap.name
tap_item.icon = nil
tap_item.icons = table.clone(tap.icons)
tap_item.order = data.raw.item.pump.order .. '-a[tapper]'

local tap_recipe = {
    type = 'recipe',
    name = tap.name,
    enabled = false,
    unlocked_by = 'automation-2',
    ingredients = {
        {type='item', name=iron_chest.name, amount=1},
        {type='item', name='engine-unit', amount=1},
    },
    results = {
        {type='item', name=tap.name, amount=1},
    }
}


data:extend{
    { type='recipe-category', name=fns 'barrelling' },
    tap,
    tap_item,
    tap_recipe
}