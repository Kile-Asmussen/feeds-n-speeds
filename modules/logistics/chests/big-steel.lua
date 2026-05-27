
local fns = require 'fns'
local gadgets = require 'gadgets'

local utils = 
local set = table.intoset

local double_fields = 

local upscale = gadgets.scale_vectors_and_numbers(
  2.0,
  set{
    'max_health', 'scale', 'number', 'volume_multiplier',
    'inventory_size', 
}
)

local function upscale(v, k)
  if
    type(v) == 'table' and #v == 2
    and type(v[1]) == 'number' and type(v[2]) == 'number'
  then
    table.vecmul(v, 2)
    return true
  elseif
    double_fields[k] and type(v) == 'number'
  then
    return v * 2, true
  end
end

local function shift_wire(v, k)
  if table.isvec(v) then
    table.vecadd(v, {0.35, 0.30})
    return true
  end
end

local big_steel_chest = table.clone(data.raw.container['steel-chest'])

table.merge(big_steel_chest, {
    name = fns 'big-steel-chest',
    dying_explosion = fns 'big-steel-chest-explosion',
    minable = table.assign{'result', val = fns 'big-steel-chest'},
    icon = functions.null,
    icons = {
        {
            icon = '__base__/graphics/icons/steel-chest.png',
            icon_size = 64,
            scale = 0.5
        },
        {
            icon = '__base__/graphics/icons/arrows/up-arrow.png',
            icon_size = 64,
            float = true,
            scale = 0.25,
            shift = { -8, 8 },
            tint = { r = 0.2, g = 1, b = 0.2 },
        },
    },

})

-- switcheroo to avoid upscaling the 
local circuit_connector = big_steel_chest.circuit_connector
big_steel_chest.circuit_connector = {}

table.traverse(circuit_connector, shift_wire)
table.traverse(big_steel_chest, upscale)

big_steel_chest.circuit_connector = circuit_connector

local big_steel_item = table.clone(data.raw.item['steel-chest'])

table.merge(big_steel_item, {
    name = fns 'big-steel-chest',
    place_result = big_steel_chest.name,
    drop_sound = table.assign{ 'volume', val = 1.0 },
    inventory_move_sound = table.assign{ 'volume', val = 1.0 },
    pick_sound = table.assign{ 'volume', val = 1.0 },
    order = 'a[items]-d[big-steel-chest]',
})

local big_steel_recipe = table.clone(data.raw.recipe['steel-chest'])

table.merge(big_steel_recipe, {
    name = fns 'big-steel-chest',
    auto_unlocked_by = 'automation-1',
    results = {
        { amount = 1, name = fns 'big-steel-chest', type = 'item' }
    }
    ingredients = {
        { amount = 4, name = 'steel-chest', type = 'item', },
        { amount = 4, name = 'electronic-circuit', type = 'item', }
    },
})

local 

data:extend{
    big_steel_chest,
    big_steel_item,
    big_steel_recipe,
}

