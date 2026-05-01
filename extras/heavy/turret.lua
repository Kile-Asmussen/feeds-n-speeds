require 'prelude'

local turret = table.clone(data.raw['ammo-turret']['gun-turret'])

turret.name = fns 'shotgun-turret'
turret.icon = '__base__/graphics/icons/gun-turret.png'
turret.minable = { mining_time = 0.5, result = fns 'shotgun-turret' }
turret.attack_parameters = table.clone(turret.attack_parameters)
turret.attack_parameters.ammo_category = 'shotgun-shell'
turret.attack_parameters.cooldown = 30
turret.attack_parameters.range = 12
turret.attack_parameters.shell_particle = nil
turret.fast_replaceable_group = nil

local turret_item = {
    type = 'item',
    name = fns 'shotgun-turret',
    icon = '__base__/graphics/icons/gun-turret.png',
    subgroup = 'defensive-structure',
    order = 'b[turret]-b[shotgun-turret]',
    place_result = fns 'shotgun-turret',
    stack_size = 50,
}

local turret_recipe = {
    type = 'recipe',
    name = fns 'shotgun-turret',
    enabled = false,
    ingredients = table.clone(data.raw.recipe['gun-turret']),
    results = {
        { type = 'item', name = fns 'shotgun-turret', amount = 1 },
    }
}
table.insert(turret_recipe.ingredients, {type='item', name='stone-brick', amount=5})

local turret_tech = table.clone(data.raw.technology['gun-turret'])

turret_tech.name = fns 'shotgun-turret-tech'
turret_tech.prerequisites = { 'gun-turret', 'military-2' }
turret_tech.effects = {
    { type = 'recipe-unlock', recipe=fns 'shotgun-turret' }
}
turret_tech.unit = {
    count = 20,
    ingredients = {
        { 'automation-science-pack', 1 },
        { 'logistic-science-pack', 1 },
    },
    time = 10
}

return {
    turret,
    turret_item,
    turret_recipe,
    turret_tech
}
