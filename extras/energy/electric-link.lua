require 'prelude'

local link = table.clone(data.raw.accumulator.accumulator)
local switch = data.raw['power-switch']['power-switch']

link.name = fns 'electric-link'
-- link.localised_description = {""}

local list = {}
setmetatable(list, { __index = table.insert })

for _, field in ipairs(
    list
    .corpse
    .dying_explosion
    .damaged_trigger_effedt
    .fast_replaceable_group
    .icon
    .frozen_patch
    .max_health
    .open_sound
    .selection_box
    .working_sound
    .water_reflection
) do
    link[field] = table.clone(switch[field])
end

link.default_output_signal = {
    name = 'signal-lightning',
    type = 'virtual',
}

local link_item = table.clone(data.raw.item['power-switch'])

link_item.name = fns 'electric-link'

link_item.icons = {
    {
        icon = switch.icon,
        icon_size = 64,
        scale = 0.5
    },
    {
        icon = data.raw['signal-rightwards-leftwards-arrow'].icon,
        floating = true,
        icon_size = 64,
        tint = { 0, 1, 0 }
        scale = 0.33,
        shift = { 6, -6 }
    },
}

link_item.placeable_result=fns 'electric-link',

local link_recipe = table.clone(data.raw.recipe['accumulator'])

link_recipe.category = 'electronics-with-fluid'

link_recipe.ingredients = {
    { type='item', amount=1, name='power-switch' }
    { type='item', amount=20, name='copper-cable' }
    { type='fluid', amount=50, name='light-oil' }
}

link_recipe.results = {
    { type='item', amount=1, name=fns 'electric-link' },
}