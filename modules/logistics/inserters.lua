--! data: tweaks to inserter speeds
local fns = require 'fns'
local table = fns.table

local merge = table.merge

local function scale(v, k)
    if k == 'scale' then
        return v*2, true
    elseif k == 'shift' then
        fns.math.vecmul(v, 2.0)
        return true
    end
end

merge(data.raw.inserter, {
    ['inserter'] = merge{
        extension_speed = 0.05,
        rotation_speed = 0.025,
        filter_count = 4,
        chases_belt_items = false,
        allow_burner_leech = true,
    },
    ['long-handed-inserter'] = merge{
        extension_speed = 0.07,
        rotation_speed = 0.025,
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
        rotation_speed = 0.01,
        extension_speed = 0.02,
        allow_burner_leech = true,
    }
})

local crane = table.deepcopy(data.raw.inserter['burner-inserter'])

table.traverse(crane, scale)

merge(crane, {
    __del = {'next_upgrade', 'icon'},
    name = fns 'crane',
    bulk = true,
    energy_source = {
        type = 'electric',
        usage_priority = 'secondary-input',
        drain = '5kW',
    },
    icons = {
        fns.gadgets.icon('icons/burner-inserter.png'),
        fns.gadgets.floating_icon('bottomleft', 'signal-stack-size', { scale = 0.35, tint = {0,0,0} }),
        fns.gadgets.floating_icon('bottomleft', 'signal-stack-size'),
        fns.gadgets.floating_icon('topleft', 'up-arrow', { tint = { 0, 1, 0} }),
    },
    uses_inserter_stack_size_bonus = false,
    allow_custom_vectors = false,
    wait_for_full_hand = true,
    max_belt_stack_size = 1,
    filter_count = 4,
    circuit_wire_max_distance = 9,
    rotation_speed = 0.0125,
    extension_speed = 0.025,
    insert_position = { 0, 1.9 },
    pickup_position = { 0, -1.5 },
    energy_per_movement = "200kJ",
    energy_per_rotation = "200kJ",
    hand_size = 1.4,
    stack_size_bonus = 249,
    max_health = 400,
    order = 'z',
    subgroup = 'inserter',
    heating_energy = '300kW',
    collision_box = { { -0.15, -0.65 }, { 0.15, 0.65 } },
    selection_box = { { -0.4, -0.6 }, { 0.4, 1.0 } },
    minable = { __merge = true, result = fns 'crane' },
    surface_conditions = {
        { property = 'gravity', min = 0.1 }
    },
    auto_require_pavement = 'refined-hazard-concrete',
    dying_explosion = 'locomotive-explosion',
    corpse = fns 'crane-remnants',
})

merge(crane, table.select(
    data.raw.inserter['stack-inserter'],
    {
        'hand_open_frozen', 'hand_open_picture', 'hand_open_shadow',
        'hand_closed_frozen', 'hand_closed_picture', 'hand_closed_shadow',
    }
))

local crane_corpse = table.deepcopy(data.raw.corpse['burner-inserter-remnants'])

table.traverse(crane_corpse.animation, scale)

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
    order = 'z',
    subgroup = 'inserter',
    place_result = fns 'crane',
    stack_size = 5,
    icons = table.deepcopy(crane.icons),
    order = 'z',

}


local crane_recipe = {
    type = "recipe",
    name = fns 'crane',
    category = 'advanced-crafting',
    energy_required = 10,
    order = 'z',
    subgroup = 'inserter',
    allow_decomposition = true,
    icons = table.deepcopy(crane.icons),
    ingredients = fns.gadgets.throughputs{
        ['steel-plate'] = 10,
        ['electric-engine-unit'] = 10,
        ['efficiency-module'] = 1,
        ['bulk-inserter'] = 1,
    },
    results = fns.gadgets.throughputs{
        [fns'crane'] = 1
    },
    auto_unlocked_by = fns 'crane',
}

local crane_tech = {
    type = 'technology',
    name = fns 'crane',
    prerequisites = { 'efficiency-module', 'automated-rail-transportation', fns'concrete-rail' },
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
