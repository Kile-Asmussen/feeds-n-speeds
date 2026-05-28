local fns = require 'fns'
local turret = table.clone(data.raw['ammo-turret']['gun-turret'])

turret.name = fns 'shotgun-turret'
turret.icon = nil
turret.minable = { mining_time = 0.5, result = fns 'shotgun-turret' }
turret.attack_parameters = table.clone(data.raw.gun['combat-shotgun'].attack_parameters)
turret.attack_parameters.damage_modifier = nil
turret.fast_replaceable_group = 'ammo-turret'
turret.max_health = 900

for _, layer in ipairs(turret.graphics_set.base_visualisation.animation.layers) do
    layer.tint = { 1, 0.3, 0.3 }
end

local turret_item = {
    type = 'item',
    name = fns 'shotgun-turret',
    icons = {
        { icon = '__base__/graphics/icons/gun-turret.png', size = 64, scale = 0.5 },
        { icon = data.raw.ammo['shotgun-shell'].icon, size = 64, scale = 0.25, shift = { -8, 8 } }
    },
    subgroup = data.raw.item['gun-turret'].subgroup,
    order = 'b[turret]-b[shotgun-turret]',
    place_result = fns 'shotgun-turret',
    stack_size = 10,
}

turret.icons = table.clone(turret_item.icons)

local turret_recipe = {
    type = 'recipe',
    energy_required = 8,
    name = fns 'shotgun-turret',
    enabled = false,
    ingredients = {
        { type='item', name='electronic-circuit', amount=8 },
        { type='item', name='steel-plate', amount=4 },
        { type='item', name='combat-shotgun', amount=2 },
        { type='item', name='iron-gear-wheel', amount=8 },
        { type='item', name='stone-brick', amount=10 },
    },
    results = {
        { type = 'item', name = fns 'shotgun-turret', amount = 1 },
    }
}
table.insert(turret_recipe.ingredients, {type='item', name='stone-brick', amount=5})

local turret_tech = table.clone(data.raw.technology['gun-turret'])
turret_tech.name = fns 'shotgun-turret-tech'
turret_tech.prerequisites = { 'gun-turret', 'military-2' }
turret_tech.effects = {
    { type = 'unlock-recipe', recipe=fns 'shotgun-turret' }
}
turret_tech.unit = {
    count = 20,
    ingredients = {
        { 'automation-science-pack', 1 },
        { 'logistic-science-pack', 1 },
    },
    time = 10
}

turret_tech.icons = {
    { 
        icon = turret_tech.icon,
        icon_size = 256,
        scale = 0.5
    },
    { 
        icon = data.raw.technology['military'].icon,
        icon_size = 256,
        float = true,
        scale = 0.33,
        tint = { 1, 0.2, 0.2 },
        shift = { 20, 20 }
    },
}

data:extend{
    turret,
    turret_item,
    turret_recipe,
    turret_tech
}