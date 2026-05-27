local fns = require 'fns'
local link = table.clone(data.raw.accumulator.accumulator)
local switch = data.raw['power-switch']['power-switch']

link.name = fns 'electric-link'
-- link.localised_description = {""}

local list = {}
setmetatable(list, { __index = function(t, k) table.insert(t, k) return t end })

for _, field in ipairs(
    list
    .corpse
    .dying_explosion
    .damaged_trigger_effect
    .fast_replaceable_group
    .icon
    -- .frozen_patch
    .max_health
    .open_sound
    .selection_box
    .working_sound
    -- .water_reflection
) do
    assert(link[field] and switch[field], "no such field: " .. field)
    link[field] = table.clone(switch[field])
end

link.default_output_signal = {
    name = 'signal-lightning',
    type = 'virtual',
}

link.energy_source = {
    buffer_capacity = '85kJ',
    input_flow_limit = '5MW',
    output_flow_limit = '5MW',
    type = 'electric',
    usage_priority = 'primary-input'
}

-- link.chargeable_graphics.c

link.minable.result = link.name

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

local animation_layers = table.clone(link.chargable_graphics.picture.layers)
animation_layers[1].repeat_count = switch.overlay_loop.frame_count
animation_layers[2].repeat_count = switch.overlay_loop.frame_count

link.chargable_graphics.charge_animation = {
    layers = {
        {
            layers = animation_layers
        },
        table.clone(switch.overlay_loop)
    }
}

link.chargable_graphics.discharge_animation = table.clone(link.chargable_graphics.charge_animation)

link.icons = {
    {
        icon = switch.icon,
        icon_size = 64,
        tint = { 1.0, 1.0, 0.6 },
        scale = 0.5,
    },
    {
        icon = data.raw['virtual-signal']['signal-rightwards-leftwards-arrow'].icon,
        floating = true,
        icon_size = 64,
        tint = { 0, 1, 0 },
        scale = 0.33,
        shift = { 6, -6 },
    },
}

table.traverse(link.chargable_graphics, function(x)
    if x == "__base__/graphics/entity/accumulator/accumulator.png" then
        return "__base__/graphics/entity/power-switch/power-switch.png", true
    elseif x == "__base__/graphics/entity/accumulator/accumulator-shadow.png" then
        return "__base__/graphics/entity/power-switch/power-switch-shadow.png", true
    end
end)

local link_item = table.clone(data.raw.item['power-switch'])

link_item.name = fns 'electric-link'

link_item.icons = table.clone(link.icons)

link_item.place_result=fns 'electric-link'

link_item.subgroup = data.raw.item.substation.subgroup
link_item.order = data.raw.item.substation.order .. '-b[link]'

local link_recipe = table.clone(data.raw.recipe['accumulator'])

link_recipe.name = fns 'electric-link'
link_recipe.category = 'electronics-with-fluid'
link_recipe.auto_unlocked_by = 'electric-energy-distribution-2'

link_recipe.ingredients = {
    { type='item', amount=20, name='iron-plate' },
    { type='item', amount=20, name='copper-cable' },
    { type='fluid', amount=50, name='light-oil' },
}

link_recipe.results = {
    { type='item', amount=1, name=fns 'electric-link' },
}

data:extend{
    link,
    link_recipe,
    link_item,
}
