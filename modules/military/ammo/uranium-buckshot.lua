require 'prelude'

local ushell = table.clone(data.raw.ammo['piercing-shotgun-shell'])
local ushell_proj = table.clone(data.raw.projectile['piercing-shotgun-pellet'])
local ushell_recipe = table.clone(data.raw.recipe['uranium-rounds-magazine'])

ushell_proj.name = fns 'uranium-shotgun-pellet'
ushell_proj.action.action_delivery.target_effects.damage.amount = 16

ushell.name = fns 'uranium-shotgun-shell'

ushell_recipe.name = ushell.name
ushell_recipe.ingredients[1].name = 'piercing-shotgun-shell'
ushell_recipe.results[1].name = ushell.name

ushell.icon = nil
ushell.icons = {
    {
        icon = data.raw.ammo['piercing-shotgun-shell'].icon,
        icon_size = 64,
        scale = 0.5,
        tint = { 0.3, 1, 0.3 },
    }
}

if ushell.ammo_type.action[1].repeat_count then
    ushell.ammo_type.action[1].action_delivery.projectile = ushell_proj.name
else
    ushell.ammo_type.action[2].action_delivery.projectile = ushell_proj.name
end

table.insert(data.raw.technology['uranium-ammo'].effects,
    {type='unlock-recipe', recipe=fns 'uranium-shotgun-shell'})

prototype(
    ushell,
    ushell_proj,
    ushell_recipe,
)
