--! data: big expensive powerful turret that fires cannon shell
local fns = require 'fns'
local table = fns.table
local math = fns.math

local turret = table.deepcopy(data.raw['ammo-turret']['gun-turret'])
local name = fns 'cannon-turret'

turret.name = name
turret.icon = '__base__/graphics/icons/gun-turret.png'
turret.minable = { mining_time = 3.0, result = name }
turret.attack_parameters = table.deepcopy(data.raw.gun['tank-cannon'].attack_parameters)
turret.fast_replaceable_group = 'ammo-turret'
turret.max_health = 1000

turret.automated_ammo_count = 30
turret.inventory_size = 2
turret.attack_parameters.min_range = 5
turret.attack_parameters.range = 25
turret.attack_parameters.cooldown = 50

turret.attack_parameters.projectile_creation_distance = 
    turret.attack_parameters.projectile_creation_distance * 2

turret.rotation_speed = 0.01
turret.preparing_speed = 0.06
turret.folding_speed = 0.06
turret.attacking_speed = 0.3

local turret_remnants = table.deepcopy(data.raw.corpse['gun-turret-remnants'])
turret_remnants.name = fns 'cannon-turret-remnants'
turret_remnants.selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } }
turret_remnants.tile_width = 3
turret_remnants.tile_height = 3

turret.corpse = turret_remnants.name
turret.collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } }
turret.selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } }

local layers_list = {
    turret.graphics_set.base_visualisation.animation.layers,
    turret.preparing_animation.layers,
    turret.prepared_animation.layers,
    turret.attacking_animation.layers,
    turret.folded_animation.layers,
    turret.folding_animation.layers,
}
table.append(layers_list, table.icollect(turret_remnants.animation, table.access{'layers'}))

for _, layers in ipairs(layers_list) do
    for _, layer in ipairs(layers) do
        if not layer.draw_as_shadow then
            layer.tint = { 0.3, 0.3, 0.3 }
        end
        layer.scale = layer.scale * 1.5
        math.vecmul(layer.shift, 1.5)
    end
end
turret.water_reflection.pictures.scale = 7.5

table.traverse(turret.circuit_connector, function(v)
    if math.isvec(v) then
        math.vecadd(v, { -0.3, 0.3 })
        return true
    end
end)

local turret_item = {
    type = 'item',
    name = name,
    icon = '__base__/graphics/icons/gun-turret.png',
    subgroup = data.raw.item['gun-turret'].subgroup,
    order = 'b[turret]-b[shotgun-turret]',
    place_result = name,
    stack_size = 5,
}

turret_item.icons = {
    {
        icon = '__base__/graphics/icons/gun-turret.png',
        tint = { 0.8, 0.8, 0.8 }
    },
    {
        icon = data.raw.ammo['cannon-shell'].icon,
        float = true,
        scale = 0.25,
        shift = { -8, 8 },
    }
}

turret.icons = table.deepcopy(turret_item.icons)

local turret_recipe = {
    type = 'recipe',
    energy_required = 8,
    name = name,
    auto_unlocked_by = fns 'cannon-turret-tech',
    enabled = false,
    ingredients = {
        { type='item', name='advanced-circuit', amount=2 },
        { type='item', name='arithmetic-combinator', amount=1 },
        { type='item', name='engine-unit', amount=2 },
        { type='item', name='iron-gear-wheel', amount=10 },
        { type='item', name='steel-plate', amount=10 },
        { type='item', name='hazard-concrete', amount=20 },
    },
    results = {
        { type = 'item', name = name, amount = 1 },
    }
}

local turret_tech = table.deepcopy(data.raw.technology['gun-turret'])

data.raw.recipe['cannon-shell'].auto_unlocked_by = fns 'cannon-turret-tech'

turret_tech.name = fns 'cannon-turret-tech'
turret_tech.prerequisites = { 'gun-turret', 'military-3', 'explosives' }
turret_tech.effects = {

    { type='unlock-recipe', recipe='cannon-shell' },
}

turret_tech.unit = table.deepcopy(data.raw.technology.tank.unit)

turret_tech.icons = {
    { 
        icon = turret_tech.icon,
        icon_size = 256,
        tint = { 0.5, 0.5, 0.5 },
        scale = 0.5
    },
    { 
        icon = data.raw.technology['explosives'].icon,
        icon_size = 256,
        float = true,
        scale = 0.25,
        shift = { 30, 30 }
    },
}

data.raw.technology.tank.prerequisites = { fns 'cannon-turret-tech', 'automobilism', 'flammables' }

table.merge(data.raw.recipe['tank'], {
    ingredients = fns.gadgets.throughputs{
        ['engine-unit'] = 24, ['steel-plate'] = 80, ['pipe'] = 8, ['advanced-circuit'] = 10,
        [fns 'cannon-turret'] = 1, ['submachine-gun'] = 1, ['flamethrower'] = 1,
    }
})

data:extend{
    turret,
    turret_remnants,
    turret_item,
    turret_recipe,
    turret_tech
}