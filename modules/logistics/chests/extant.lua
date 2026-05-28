
if true then return end

local fns = require 'fns'
local gadgets = require 'gadgets'

local utils = fns.utils
local set = table.intoset

local upscale = gadgets.scale_vectors_and_numbers(
  2.0,
  set{
    'scale', 'number', 'volume_multiplier',
    'inventory_size', 
  },
  table.fullset,
  set{ 'circuit_connector' },
)

local shift_wire = gadgets.shift_vectors(
  {0.35, 0.30}, set{'shift'}
)

table.merge(data.raw.container, {
    ['wooden-chest'] = table.merge{
        circuit_connector = nil,
        inventory_size = 10
        max_health = 100,
    },
    ['iron-chest'] = utils.call(
        table.merge{
            circuit_connector = shift_wire,
            inventory_size = 30,
            max_health = 250,
        },
        upscale
    )
    ['steel-chest'] = utils.call(
        table.merge{
            circuit_connector = shift_wire,
            inventory_size = 80,
            inventory_type = 'with_filters_and_bar',
            max_health = 500,
            quality_affects_inventory_size = true,
            flags = { 
                'placeable-neutral',
                'player-creation',
                'get-by-unit-number',
            }
        },
        upscale
    )
})

table.merge(data.raw.explosion, {
    ['steel-chest-explosion'] = upscale,
    ['iron-chest-explosion'] = upscale,
})

table.merge(data.raw.corpse, {
    ['steel-chest-remnants'] = upscale,
    ['iron-chest-remnants'] = upscale,
})