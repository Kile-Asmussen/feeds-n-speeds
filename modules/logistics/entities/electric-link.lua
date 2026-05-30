--! data: electrical infrastructure entity that can limit power transfer between unconnected networks
local fns = require 'fns'
local merge = fns.table.merge
local switch = data.raw['power-switch']['power-switch']

local link = table.merge(table.clone(data.raw.accumulator.accumulator), {
    name = fns 'electric-link',
    default_output_signal = {
        name = 'signal-lightning',
        type = 'virtual',
    },
    energy_source = {
        buffer_capacity = '85kJ', -- ca. 5MW * 1s / 60
        input_flow_limit = '5MW',
        output_flow_limit = '5MW',
        type = 'electric',
        usage_priority = 'primary-input'
    },
    minable = table.assign{'result', val = fns 'electric-link'}
})

for _, field in ipairs{
    'corpse',
    'dying_explosion',
    'damaged_trigger_effect',
    'fast_replaceable_group',
    'icon',
    'max_health',
    'open_sound',
    'selection_box',
    'working_sound',
} do
    assert(link[field] and switch[field], "no such field: " .. field)
    link[field] = table.clone(switch[field])
end


link.chargable_graphics.picture = {
    layers = {
        {
            filename = '__base__/graphics/entity/power-switch/power-switch.png',
            height = 138,
            x = 168,
            y = 2 * 138,
            scale = 0.5,
            shift = {
                -0.09375,
                0.0625
            },
            tint = { 1.0, 1.0, 0.6 },
            width = 168
        },
        {
            draw_as_shadow = true,
            filename = '__base__/graphics/entity/power-switch/power-switch-shadow.png',
            height = 92,
            scale = 0.5,
            x = 166,
            y = 2 * 92,
            shift = {
            0.1875,
            0.4375
            },
            width = 166
        }
    },
}

local animation_layers = table.merge(table.clone(link.chargable_graphics.picture.layers), {
    __rec = true,
    [{1, 2}] = { repeat_count = switch.overlay_loop.frame_count }
})

local charge_animation = {
    layers = { { layers = animation_layers },
    table.clone(switch.overlay_loop) }
}

table.merge(link.chargable_graphics, {
    charge_animation = charge_animation,
    discharge_animation = table.clone(charge_animation),
})

link.icons = fns.gadgets.icons{
    { switch.icon, tint = { 1.0, 1.0, 0.6 }, },
    {
        data.raw['virtual-signal']['signal-rightwards-leftwards-arrow'].icon,
        tint = { 0, 1, 0 },
        size = 'medium',
        dir = 'tr',
    },
}

table.traverse(link.chargable_graphics, function(x)
    if x == "__base__/graphics/entity/accumulator/accumulator.png" then
        return "__base__/graphics/entity/power-switch/power-switch.png", true
    elseif x == "__base__/graphics/entity/accumulator/accumulator-shadow.png" then
        return "__base__/graphics/entity/power-switch/power-switch-shadow.png", true
    end
end)

 

local link_item = table.merge(table.clone(data.raw.item['power-switch']), {
    name = fns 'electric-link',
    icons = table.clone(link.icons),
    place_result=fns 'electric-link',
    subgroup = data.raw.item.substation.subgroup,
    order = data.raw.item.substation.order .. '-b[link]',
})

local puts = fns.gadgets.throughputs

local link_recipe = table.merge(table.clone(data.raw.recipe['accumulator']), {

    name = fns 'electric-link',
    category = 'electronics-with-fluid',
    auto_unlocked_by = fns 'electric-heater',

    ingredients = puts{ ['iron-plate'] = 20, ['copper-cable'] = 20, ['light-oil'] = 50 },
    results = puts{ [fns 'electric-link'] = 1 },
})

data:extend{
    link,
    link_recipe,
    link_item,
}
