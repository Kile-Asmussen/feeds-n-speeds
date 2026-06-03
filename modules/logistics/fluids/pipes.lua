--! data: unhide the three valve prototypes and add an instrumented pipe (1x1 storage tank)
local fns = require 'fns'
local table = fns.table
local inputs = fns.gadgets.throughputs

-- tints matching the logistic chest color language:
--   one-way   -> green-blue (buffer chest: controlled flow)
--   overflow  -> red        (passive provider: drains excess)
--   top-up    -> blue       (requester: fills to threshold)
local valve_tints = {
    ['one-way-valve']  = { r = 0.2, g = 0.8, b = 0.7, a = 0.7 },
    ['overflow-valve'] = { r = 0.9, g = 0.1, b = 0.1, a = 0.7 },
    ['top-up-valve']   = { r = 0.1, g = 0.4, b = 0.9, a = 0.7 },
}

for name, tint in pairs(valve_tints) do
    local entity = data.raw.valve[name]
    local item   = data.raw.item[name]

    entity.hidden = false
    item.hidden   = false

    item.icons = {
        { icon = entity.icon, icon_size = 64 },
        { icon = entity.icon, icon_size = 64, tint = tint },
    }

    item.subgroup = 'energy-pipe-distribution'
    item.auto_unlocked_by = 'fluid-handling'
end

for name in pairs(valve_tints) do
    data:extend{{
        type             = 'recipe',
        name             = name,
        ingredients      = inputs{ ['iron-plate'] = 2, ['pipe'] = 1 },
        results          = { { type = 'item', name = name, amount = 1 } },
        energy_required  = 1,
        enabled          = false,
        auto_unlocked_by = 'fluid-handling',
    }}
end

local pipe_cross = '__base__/graphics/entity/pipe/pipe-cross.png'

local instrumented_pipe = table.deepcopy(data.raw['storage-tank']['storage-tank'])
instrumented_pipe.name              = fns 'instrumented-pipe'
instrumented_pipe.localised_name    = { 'entity-name.' .. fns 'instrumented-pipe' }
instrumented_pipe.collision_box     = { { -0.4, -0.4 }, { 0.4, 0.4 } }
instrumented_pipe.selection_box     = { { -0.5, -0.5 }, { 0.5, 0.5 } }
instrumented_pipe.two_direction_only = false
instrumented_pipe.fluid_box.volume  = 100
instrumented_pipe.fluid_box.pipe_connections = {
    { position = {  0, -1 }, direction = defines.direction.north },
    { position = {  1,  0 }, direction = defines.direction.east  },
    { position = {  0,  1 }, direction = defines.direction.south },
    { position = { -1,  0 }, direction = defines.direction.west  },
}
instrumented_pipe.minable           = { mining_time = 0.1, result = fns 'instrumented-pipe' }
instrumented_pipe.corpse            = 'pipe-remnants'
instrumented_pipe.dying_explosion   = 'pipe-explosion'
instrumented_pipe.max_health        = 100
instrumented_pipe.window_bounding_box = { { 0, 0 }, { 0, 0 } }
instrumented_pipe.icon              = pipe_cross
instrumented_pipe.icon_draw_specification = { scale = 0.5 }
instrumented_pipe.pictures = {
    picture = {
        sheets = {
            { filename = pipe_cross, width = 128, height = 128, scale = 0.5, priority = 'extra-high' },
        }
    },
    flow_sprite        = data.raw['storage-tank']['storage-tank'].pictures.flow_sprite,
    fluid_background   = data.raw.pipe.pipe.pictures.fluid_background,
    gas_flow           = data.raw['storage-tank']['storage-tank'].pictures.gas_flow,
    window_background  = data.raw['storage-tank']['storage-tank'].pictures.window_background,
}

data:extend{ instrumented_pipe }

data:extend{
    {
        type            = 'item',
        name            = fns 'instrumented-pipe',
        icon            = pipe_cross,
        icon_size       = 128,
        icon_draw_specification = { scale = 0.5 },
        place_result    = fns 'instrumented-pipe',
        stack_size      = 50,
        subgroup        = 'energy-pipe-distribution',
        order           = 'c-b',
        drop_sound      = data.raw.item.pipe.drop_sound,
        pick_sound      = data.raw.item.pipe.pick_sound,
        inventory_move_sound = data.raw.item.pipe.inventory_move_sound,
    },
    {
        type             = 'recipe',
        name             = fns 'instrumented-pipe',
        ingredients      = inputs{ ['pipe'] = 1, ['electronic-circuit'] = 1 },
        results          = { { type = 'item', name = fns 'instrumented-pipe', amount = 1 } },
        energy_required  = 1,
        enabled          = false,
        auto_unlocked_by = 'fluid-handling',
    },
}
