--! data: tweaks to inserter speeds
local fns = require 'fns'
local table = fns.table

local merge = table.merge

merge(data.raw.inserter, {
    ['inserter'] = merge{
        extension_speed = 0.05,
        rotation_speed = 0.03,
        filter_count = 4,
        chases_belt_items = false,
        allow_burner_leech = true,
    },
    ['long-handed-inserter'] = merge{
        extension_speed = 0.1,
        rotation_speed = 0.03,
        filter_count = 4,
        chases_belt_items = false,
        allow_burner_leech = true,
    },
    [{
        'fast-inserter',
        'bulk-inserter',
        'stack-inserter',
    }] = merge{
        rotation_speed = 0.05,
        extension_speed = 0.1,
        filter_count = 4,
        chases_belt_items = false,
        allow_burner_leech = true,
    },
    ['burner-inserter'] = merge{
        chases_belt_items = false,
        filter_count = 1,
        rotation_speed = 0.015,
        extension_speed = 0.025,
        allow_burner_leech = true,
    }
})

local crane = table.deepcopy(data.raw.inserter['burner-inserter'])

table.traverse(crane, function(v, k)
    if k == 'scale' then
        return v*2, true
    end
end)

merge(crane, {
    __del = {'next_upgrade', 'icon'},
    name = fns 'crane',
    bulk = true,
    energy_source = {
        type = 'electric',
        priority = 'secondary-input',
        drain = '5kW',
    },
    icons = {
        fns.gadgets.icon('icons/burner-inserter.png'),
        fns.gadgets.floating_icon('bottomleft', 'icons/burner-inserter.png'),
        fns.gadgets.floating_icon('topleft', 'icons/', { tint = { 0, 1, 0} }),
    },
    uses_inserter_stack_size_bonus = false,
    allow_custom_vectors = false,
    wait_for_full_hand = true,
    max_belt_stack_size = 10,
    filter_count = 2,
    circuit_wire_max_distance = 8,
    extension_speed = 0.0125,
    rotation_speed = 0.0075,
    insert_position = { 0, 1.7 },
    pickup_position = { 0, -1.5 },
    starting_distance = 0.5,
    energy_per_movement = "200kJ",
    energy_per_rotation = "200kJ",
    hand_size = 1000,
    max_health = 400,
    heating_energy = '300kW',
    collision_box = { { -1.3, -0.8 }, { 1.3, 0.8 } },
    selection_box = { { -1.5, -1.0 }, { 1.5, 1.0 } },
    minable = { __merge = true, result = fns 'crane' },
    surface_conditions = {
        { name = 'gravity', min = 0.1 }
    },
    auto_require_pavement = 'hazard-concrete',
    dying_explosion = 'locomotive-explosion',
    corpse = fns 'crane-remnants',
})

local crane_corpse = table.deepcopy(data.raw.corpse['inserter-remnants'])

table.traverse(crane_corpse.animation, function(v, k)
    if k == 'scale' then
        return v*2, true
    elseif k == 'shift' then
        fns.math.vecmul(v, 2.0)
        return true
    end
end)

merge(crane_corpse, {
    name = fns 'crane-remnants',
    localised_name = { "remnant-name", { fns.locale_key('entity-name', 'crane') } },
    selection_box = table.deepcopy(crane.selection_box),
    tile_height = 2,
    tile_width = 3,
})

local crane_item = {
    type = "item",
    name = fns 'crane',
    place_result = fns 'crane',
    stack_size = 5,
    icons = table.deepcopy(crane.icons),
}


local crane_recipe = {
    type = "recipe",
    name = fns 'crane',
    category = 'advanced-crafting',
    energy_required = 10,
    allow_decomposition = true,
    ingredients = fns.gadgets.throughputs{
        ['steel-plate'] = 10,
        ['electric-engine-unit'] = 10,
        ['advanced-circuit'] = 2,
        ['iron-chest'] = 1,
        inserter = 1,
    },
    auto_unlocked_by = fns 'crane',
}

local crane_tech = {
    type = 'technology',
    name = fns 'crane',
    prerequisites = { 'advanced-circuit', 'automated-rail-transportation', fns'concrete-rail' },
    icons = {
        fns.gadgets.icon('technology/railway.png', 256),
        fns.gadgets.icon('technology/inserter-capacity.png', {icon_size=256, tint={0.5,0.5,0.5}}),
    },
    research_trigger = {
        type='craft-item',
        item='cargo-wagon',
        count = 10,
    }
}

data:extend{
    crane,
    crane_corpse,
    crane_item,
    crane_recipe,
    crane_tech
}
