require 'prelude'

local tools = require'tools'

local turret = table.clone(data.raw['ammo-turret']['gun-turret'])
local name = fns 'cannon-turret'

turret.name = name
turret.icon = '__base__/graphics/icons/gun-turret.png'
turret.minable = { mining_time = 0.5, result = name }
turret.attack_parameters = table.clone(data.raw.gun['tank-cannon'].attack_parameters)
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


local turret_remnants = table.clone(data.raw.corpse['gun-turret-remnants'])
turret_remnants.name = fns 'cannon-turret-remnants'
turret_remnants.selection_box = { { -2, -2 }, { 2, 2 } }
turret_remnants.tile_width = 4
turret_remnants.tile_height = 4

turret.corpse = turret_remnants.name
turret.collision_box = { { -1.8, -1.8 }, { 1.8, 1.8 } }
turret.selection_box = { { -2, -2 }, { 2, 2 } }

local layers_list = {
    turret.graphics_set.base_visualisation.animation.layers,
    turret.preparing_animation.layers,
    turret.prepared_animation.layers,
    turret.attacking_animation.layers,
    turret.folded_animation.layers,
    turret.folding_animation.layers,
}
table.append(layers_list, table.icollect(turret_remnants.animation, table.at('layers')))

for _, layers in ipairs(layers_list) do
    for _, layer in ipairs(layers) do
        if not layer.draw_as_shadow then
            layer.tint = { 0.3, 0.3, 0.3 }
        end
        layer.scale = layer.scale * 2
        table.vecmul(layer.shift, 2)
    end
end
turret.water_reflection.pictures.scale = 10

table.traverse(turret.circuit_connector, function(v)
    if type(v) ~= 'table' then return end
    if #v == 2 and type(v[1]) == 'number' and type(v[2]) == 'number' then
        v[1] = v[1] - 0.3
        v[2] = v[2] + 0.3
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
    stack_size = 50,
}

turret_item.icons = tools.icons(
    { icon = '__base__/graphics/icons/gun-turret.png',
        tint = { 0.8, 0.8, 0.8 }
    }, {
        icon = data.raw.ammo['cannon-shell'].icon
    }
)

turret.icons = table.clone(turret_item.icons)

local turret_recipe = {
    type = 'recipe',
    energy_required = 8,
    name = name,
    enabled = false,
    ingredients = {
        { type='item', name='advanced-circuit', amount=2 },
        { type='item', name='arithmetic-combinator', amount=5 },
        { type='item', name='engine-unit', amount=5 },
        { type='item', name='iron-gear-wheel', amount=20 },
        { type='item', name='steel-plate', amount=20 },
        { type='item', name='hazard-concrete', amount=20 },
    },
    results = {
        { type = 'item', name = name, amount = 1 },
    }
}

local turret_tech = table.clone(data.raw.technology['gun-turret'])

turret_tech.name = fns 'cannon-turret-tech'
turret_tech.prerequisites = { 'gun-turret', 'military-3', 'explosives' }
turret_tech.effects = {
    { type='unlock-recipe', recipe=fns 'cannon-turret' },
    { type='unlock-recipe', recipe='cannon-shell' },
}

turret_tech.unit = table.clone(data.raw.technology.tank.unit)

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

data.raw.technology.tank.effects = {
    { type='unlock-recipe', recipe='tank' },
    { type='unlock-recipe', recipe='explosive-cannon-shell' },
}
data.raw.technology.tank.prerequisites = { fns 'cannon-turret-tech', 'automobilism', 'flammables' }

prototype(
    turret,
    turret_remnants,
    turret_item,
    turret_recipe,
    turret_tech
)