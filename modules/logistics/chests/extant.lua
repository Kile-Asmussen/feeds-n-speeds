
local fns = require 'fns'
local gadgets = require 'gadgets'
local inputs = gadgets.throughputs

local merge = fns.table.merge
local utils = fns.utils
local set = fns.table.intoset

local upscale = table.traverse(gadgets.scale_vectors_and_numbers(
  2.0,
  set{
    'scale', 'number', 'volume_multiplier',
  },
  table.fullset,
  set{ 'circuit_connector' }
))

local shift_wire = table.traverse(gadgets.shift_vectors(
  {0.35, 0.30}, set{'shift'}, {}
))

merge(data.raw.recipe, {
    ['wooden-chest'] = merge{
        ingredients = inputs{ ['wood'] = 6 },
    },
    ['iron-chest'] = merge{
        ingredients = inputs{ ['iron-plate'] = 6, ['iron-gear-wheel'] = 2, },
    },
    ['steel-chest'] = merge{
        auto_unlocked_by = 'automation',
        ingredients = inputs{
            ['steel-plate'] = 8,
            ['electronic-circuit'] = 8,
        }
    },
    ['storage-chest'] = merge{
        ingredients = inputs{
            ['steel-chest'] = 1,
            ['display-panel'] = 1,
        }
    },
    ['passive-provider-chest'] = merge{
        ingredients = inputs{
            ['storage-chest'] = 1,
            ['display-panel'] = 3,
            ['selector-combinator'] = 1,
        }
    },
    ['active-provider-chest'] = merge{
        allow_decomposition = true,
        ingredients = inputs{
            ['passive-provider-chest'] = 1,
            ['selector-combinator'] = 1,
            ['programmable-speaker'] = 1,
        }
    },
    ['requester-chest'] = merge{
        allow_decomposition = true,
        ingredients = inputs{
            ['active-provider-chest'] = 1,
            ['selector-combinator'] = 1,
            ['radar'] = 1,
        }
    },
    ['buffer-chest'] = merge{
        ingredients = inputs{
            ['requester-chest'] = 1,
            ['selector-combinator'] = 1,
        }
    }
})

merge(data.raw.container, {
    ['wooden-chest'] = utils.call(merge{
        circuit_connector = nil,
        inventory_size = 10,
        inventory_type = "normal",
        max_health = 100,
    }, upscale),
    ['iron-chest'] = utils.call(
        merge{
            circuit_connector = shift_wire,
            inventory_type = 'with_bar',
            inventory_size = 40,
            max_health = 250,
            quality_affects_inventory_size = true,
        },
        upscale
    ),
    ['steel-chest'] = utils.call(
        merge{
            localised_name = { fns.locale_key('entity-name', 'tweaked-steel-chest') },
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

merge(data.raw['logistic-container'], {
    ['passive-provider-chest'] = utils.call(merge{
        inventory_size = 30,
        inventory_type = "with_filters_and_bar",
        circuit_connector = shift_wire,
        max_health = 300,
        quality_affects_inventory_size = true,
    }, upscale),
    ['storage-chest'] = utils.call(merge{
        inventory_size = 1,
        inventory_type = "with_custom_stack_size",
        inventory_properties = {
            stack_size_multiplier = 30
        },
        circuit_connector = shift_wire,
        max_health = 300,
        quality_affects_inventory_size = true,
    }, upscale),
    ['active-provider-chest'] = utils.call(merge{
        inventory_size = 30,
        inventory_type = "with_filters_and_bar",
        circuit_connector = shift_wire,
        max_health = 300,
        quality_affects_inventory_size = true,
    }, upscale),
    ['requester-chest'] = utils.call(merge{
        inventory_size = 30,
        inventory_type = "with_bar",
        circuit_connector = shift_wire,
        max_health = 300,
        quality_affects_inventory_size = true,
    }, upscale),
    ['buffer-chest'] = utils.call(merge{
        inventory_size = 30,
        inventory_type = "with_bar",
        circuit_connector = shift_wire,
        max_health = 300,
        quality_affects_inventory_size = true,
    }, upscale),
})

merge(data.raw.explosion, {
    ['steel-chest-explosion'] = upscale,
    ['iron-chest-explosion'] = upscale,
    ['wooden-chest-explosion'] = upscale,
    ['active-provider-chest-explosion'] = upscale,
    ['passive-provider-chest-explosion'] = upscale,
    ['storage-chest-explosion'] = upscale,
    ['requester-chest-explosion'] = upscale,
    ['buffer-chest-explosion'] = upscale,
})

merge(data.raw.corpse, {
    ['steel-chest-remnants'] = upscale,
    ['iron-chest-remnants'] = upscale,
    ['wooden-chest-remnants'] = upscale,
    ['active-provider-chest-remnants'] = upscale,
    ['passive-provider-chest-remnants'] = upscale,
    ['storage-chest-remnants'] = upscale,
    ['requester-chest-remnants'] = upscale,
    ['buffer-chest-remnants'] = upscale,
})