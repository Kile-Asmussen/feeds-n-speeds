--! data: make chests twice as big and more expensive to build but smaller in inventory size
local fns = require 'fns'
local table = fns.table
local inputs = fns.gadgets.throughputs

local merge = fns.table.merge
local utils = fns.utils
local set = fns.table.intoset

local upscale = table.traverse(fns.gadgets.scale_vectors_and_numbers(
  2.0,
  set{
    'scale',
    'number',
    'initial_height',
    'initial_height_deviation',
    'initial_vertical_speed',
    'initial_vertical_speed_deviation',
    'speed_from_center',
    'speed_from_center_deviation',
  },
  table.fullset,
  set{ 'circuit_connector', 'sound', 'frame_count' }
))

local shift_wire = table.traverse(fns.gadgets.shift_vectors(
  {0.35, 0.30}, set{'shift'}, {}
))

merge(data.raw.recipe, {
    __rec = true,
    ['wooden-chest'] = {
        ingredients = inputs{ ['wood'] = 6 },
    },
    ['iron-chest'] = {
        ingredients = inputs{ ['iron-plate'] = 6, ['iron-gear-wheel'] = 2, },
    },
    ['steel-chest'] = {
        auto_unlocked_by = 'automation',
        ingredients = inputs{
            ['iron-chest'] = 1,
            ['steel-plate'] = 4,
            ['electronic-circuit'] = 8,
        }
    },
    ['storage-chest'] = {
        allow_decomposition = true,
        ingredients = inputs{
            ['steel-chest'] = 1,
            ['display-panel'] = 1,
        }
    },
    ['passive-provider-chest'] = {
        allow_decomposition = true,
        ingredients = inputs{
            ['storage-chest'] = 1,
            ['display-panel'] = 3,
            ['selector-combinator'] = 1,
        }
    },
    ['active-provider-chest'] = {
        allow_decomposition = true,
        ingredients = inputs{
            ['passive-provider-chest'] = 1,
            ['selector-combinator'] = 1,
            ['programmable-speaker'] = 1,
        }
    },
    ['requester-chest'] = {
        allow_decomposition = true,
        ingredients = inputs{
            ['active-provider-chest'] = 1,
            ['selector-combinator'] = 1,
            ['radar'] = 1,
        }
    },
    ['buffer-chest'] = {
        allow_decomposition = true,
        ingredients = inputs{
            ['requester-chest'] = 1,
            ['selector-combinator'] = 1,
        }
    }
})

local function make_new_ones(prototype, all, entities)
    all = all or function(x) return x end
    local res = {}
    for k, f in pairs(entities) do
        local new = table.deepcopy(prototype[k])
        prototype[k].hidden = true

        new.name = fns(k)
        new.localised_name = new.localised_name or { "entity-name." .. k }
        new.dying_explosion = new.dying_explosion and fns(k .. '-explosion') or nil
        new.corpse = new.corpse and fns(k .. '-remnants') or nil

        new.icon_draw_specification = new.icon_draw_specification or {}
        new.icon_draw_specification.scale = 0.4

        if type(f) == 'table' then f = merge(f) end

        if type(f) == 'function' then
            new = f(new)
        end
        new = all(new)

        if data.raw.item[k] then
           data.raw.item[k].place_result = new.name
        end

        table.insert(res, new)
    end
    data:extend(res)
end

make_new_ones(data.raw.container, upscale, {
    ['wooden-chest'] = {
        __del = {'circuit_connector', 'localised_name'},
        inventory_size = 10,
        inventory_type = "normal",
        max_health = 100,
    },
    ['iron-chest'] = {
        __del = 'localised_name',
        circuit_connector = shift_wire,
        inventory_type = 'with_bar',
        inventory_size = 20,
        max_health = 250,
        quality_affects_inventory_size = true,
    },
    ['steel-chest'] = {
        __del = 'localised_name',
        circuit_connector = shift_wire,
        inventory_size = 50,
        auto_require_pavement = 'stone-path',
        inventory_type = 'with_filters_and_bar',
        max_health = 500,
        quality_affects_inventory_size = true,
        flags = {
            'placeable-neutral',
            'player-creation',
            'get-by-unit-number',
        }
    }
})

make_new_ones(data.raw['logistic-container'], upscale, {
    ['passive-provider-chest'] = {
        __del = 'localised_name',
        inventory_size = 30,
        inventory_type = "with_filters_and_bar",
        auto_require_pavement = 'concrete',
        circuit_connector = shift_wire,
        max_health = 300,
        quality_affects_inventory_size = true,
    },
    ['storage-chest'] = {
        inventory_size = 4,
        inventory_type = "with_custom_stack_size",
        auto_require_pavement = 'concrete',
        inventory_properties = {
            stack_size_multiplier = 10
        },
        circuit_connector = shift_wire,
        max_health = 300,
        quality_affects_inventory_size = true,
    },
    ['active-provider-chest'] = {
        __del = 'localised_name',
        inventory_size = 20,
        inventory_type = "with_filters_and_bar",
        auto_require_pavement = 'hazard-concrete',
        circuit_connector = shift_wire,
        max_health = 300,
        quality_affects_inventory_size = true,
    },
    ['requester-chest'] = {
        inventory_size = 20,
        inventory_type = "with_bar",
        auto_require_pavement = 'hazard-concrete',
        circuit_connector = shift_wire,
        max_health = 300,
        quality_affects_inventory_size = true,
    },
    ['buffer-chest'] = {
        inventory_size = 20,
        inventory_type = "with_bar",
        auto_require_pavement = 'hazard-concrete',
        circuit_connector = shift_wire,
        max_health = 300,
        quality_affects_inventory_size = true,
    },
})

local splosions = {
    'steel-chest-explosion',
    'iron-chest-explosion',
    'wooden-chest-explosion',
    'active-provider-chest-explosion',
    'passive-provider-chest-explosion',
    'storage-chest-explosion',
    'requester-chest-explosion',
    'buffer-chest-explosion',
}

make_new_ones(data.raw.explosion, upscale, table.set(splosions))

make_new_ones(data.raw.corpse, upscale, table.set{
    'steel-chest-remnants',
    'iron-chest-remnants',
    'wooden-chest-remnants',
    'active-provider-chest-remnants',
    'passive-provider-chest-remnants',
    'storage-chest-remnants',
    'requester-chest-remnants',
    'buffer-chest-remnants',
})

for _, explo in ipairs(splosions) do

    local particles = table.icollect(
        data.raw['explosion'][explo].created_effect.action_delivery.target_effects,
        table.access{'particle_name'})

    for _, particle in ipairs(particles) do
        table.merge(data.raw['optimized-particle'][particle].pictures.sheet,
            { scale = function(n) return n * 2 end })
    end
end