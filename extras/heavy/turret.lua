require 'prelude'

local utilities = require'extras.utilities'

local turret = table.clone(data.raw['ammo-turret']['gun-turret'])
local name = fns 'shotgun-turret'

turret.name = name
turret.icon = '__base__/graphics/icons/gun-turret.png'
turret.minable = { mining_time = 0.5, result = name }
turret.attack_parameters = table.clone(data.raw.gun['combat-shotgun'].attack_parameters)
turret.attack_parameters.damage_modifier = nil
turret.fast_replaceable_group = 'ammo-turret'
turret.max_health = 500

for _, layer in ipairs(turret.graphics_set.base_visualisation.animation.layers) do
    layer.tint = { 1, 0.3, 0.3 }
end

local turret_item = {
    type = 'item',
    name = name,
    icon = '__base__/graphics/icons/gun-turret.png',
    subgroup = data.raw.item['gun-turret'].subgroup,
    order = 'b[turret]-b[shotgun-turret]',
    place_result = name,
    stack_size = 50,
}
utilities.iconify(turret_item, data.raw.ammo['shotgun-shell'].icon)

local turret_recipe = {
    type = 'recipe',
    energy_required = 8,
    name = name,
    enabled = false,
    ingredients = table.clone(data.raw.recipe['gun-turret'].ingredients),
    results = {
        { type = 'item', name = name, amount = 1 },
    }
}
table.insert(turret_recipe.ingredients, {type='item', name='stone-brick', amount=5})

local turret_tech = table.clone(data.raw.technology['gun-turret'])

turret_tech.name = fns 'shotgun-turret-tech'
turret_tech.prerequisites = { 'gun-turret', 'military-2' }
turret_tech.effects = {
    { type = 'unlock-recipe', recipe=name }
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

return {
    turret,
    turret_item,
    turret_recipe,
    turret_tech
}
