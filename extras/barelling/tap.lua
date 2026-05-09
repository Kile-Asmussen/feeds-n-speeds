require 'prelude'

local iron_chest =  data.raw.container['iron-chest']
local tap = table.clone(data.raw.furnace['stone-furnace'])


tap.name=fns 'barrel-tapper'
tap.crafting_categories = { fns 'barelling' }
tap.circuit_connector = nil
tap.collision_box = {
    { -0.5, -0.5 }, 
    { 0.5, 0.5 }, 
}
tap.selection_box = table.clone(tap.collision_box)
tap.crafting_speed = 1,

tap.corpse = iron_chest.corpse,
tap.dying_explosion = iron_chest.dying_explosion
tap.impact_category = 'metal'

tap.energy_source = {
    type='electric',
    usage_priority='secondary-input',
}
tap.energy_usage = '5kW'

tap.effects_receiver = {}

tap.graphics_set = {
    animation = table.clone(iron_chest.picture),
}

tap.close_sound = table.clone(data.raw['assembling-machine']['assembling-machine-1'].close_sound)
tap.open_sound = table.clone(data.raw['assembling-machine']['assembling-machine-1'].open_sound)

tap.fluid_boxes = {
    {
        volume = 500,
        production_type = 'input-output',
        pipe_connections = {
            {
                direction = defines.direction.north,
                flow_direction = 'input-output',
                position = {0, 0},
            },
            {
                direction = defines.direction.south, 
                flow_direction = 'input-output',
                position = {0, 0},
            },
            {
                direction = defines.direction.east,
                flow_direction = 'input-output',
                position = {0, 0},
            },
            {
                direction = defines.direction.west,
                flow_direction = 'input-output',
                position = {0, 0},
            },
        },
        pipe_covers = pipecoverspictures(),
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
        scale = 0.7,
    },
    {
        icon = data.raw.item.barrel.icon,
        scale = 0.33,
        float= true,
        shift = { 0.0, -4 },
    }
}

local tap_item = table.clone(data.raw.item['iron-chest'])
tap_item = tap.name
tap_item.place_result = tap.name
tap_item.icon = nil
tap_item.icons = table.clone(tap.icons)

local tap_recipe = {
    type = 'recipe',
    name = tap.name,
    enabled = false,
    ingredients = {
        {type='item', name='pipe', amount=2},
        {type='item', name='iron-chest', amount=2},
        {type='item', name='iron-gear-wheel', amount=4},
    },
    result = {
        {type='item', name=tap.name, amount=1},
    }
}


return {
    { type='crafting-category', name=fns 'barelling' },
    tap,
    tap_item,
    tap_recipe
}