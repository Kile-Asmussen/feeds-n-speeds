--! data: new assembling machine solely responsible for manipulating barrels
local fns = require 'fns'
local merge = fns.table.merge
local puts = fns.gadgets.throughputs
local iron_chest = data.raw.container['iron-chest']

local tap = merge(table.clone(data.raw.furnace['stone-furnace']), {
    name = fns 'barrel-tapper',
    crafting_categories = { fns 'barrelling' },
    crafting_speed = 0.2,
    circuit_connector = nil,
    collision_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
    selection_box = { { -0.4, -0.4 }, { 0.4, 0.4 } },
    cant_insert_at_source_message_key = fns.locale_key('inventory-restriction', 'cant-be-barreled'),
    custom_input_slot_tooltip_key = nil,
    corpse = fns 'barrel-tapper-remnants',
    dying_explosion = data.raw.pump.pump.explosion,
    impact_category = 'metal',
    vector_to_place_result = { -0.95, 0 },
    energy_source = { type = 'void' },
    energy_usage = '5kW',
    next_upgrade = nil,
    show_recipe_icon = false,
    effects_receiver = {},
    next_upgrade = fns.utils.null,
    graphics_set = {
        animation = merge(table.clone(iron_chest.picture), {
            __rec = true,
            layers = {
                __rec = true,
                { tint = {0.7, 0.65, 0.6}, scale = 0.6 },
                { scale = 0.6 },
            }
        }),
    },
    close_sound = table.clone(data.raw['assembling-machine']['assembling-machine-1'].close_sound),
    open_sound  = table.clone(data.raw['assembling-machine']['assembling-machine-1'].open_sound),
    fluid_boxes = {
        {
            volume = 500,
            production_type = 'input',
            pipe_connections = {
                { direction = defines.direction.north, flow_direction = 'input', position = {0, 0} },
            },
            pipe_covers = pipecoverspictures(),
            always_draw_covers = true,
        },
        {
            volume = 500,
            production_type = 'output',
            pipe_connections = {
                { direction = defines.direction.south, flow_direction = 'output', position = {0, 0} },
            },
            pipe_covers = pipecoverspictures(),
            always_draw_covers = true,
        },
    },
    minable = { mining_time = 1.0, result = fns 'barrel-tapper' },
    icon = nil,
    icons = {
        { icon = iron_chest.icon, tint = { 0.6, 0.55, 0.5 }, scale = 0.7 },
        { icon = data.raw.item.barrel.icon, scale = 0.6, float = true, shift = { 0, -3 } },
    },
})

local tap_corpse = merge(table.clone(data.raw.corpse[iron_chest.corpse]), {
    name = tap.corpse,
    selection_box = table.clone(tap.selection_box),
    animation = { __merge = true, scale = 0.6, tint = {0.7, 0.65, 0.6} },
})

local tap_item = merge(table.clone(data.raw.item[iron_chest.name]), {
    name = tap.name,
    place_result = tap.name,
    icon = nil,
    icons = table.clone(tap.icons),
    order = data.raw.item.pump.order .. '-a[tapper]',
})

local tap_recipe = {
    type = 'recipe',
    name = tap.name,
    enabled = false,
    auto_unlocked_by = 'automation-2',
    ingredients = puts{
        ['engine-unit']    = 1,
        ['pipe']           = 2,
        ['transport-belt'] = 1,
    },
    results = puts{ [tap.name] = 1 },
}

data.raw.recipe.barrel.auto_unlocked_by = 'automation-2'

data:extend{
    { type = 'recipe-category', name = fns 'barrelling' },
    tap,
    tap_corpse,
    tap_item,
    tap_recipe,
}
