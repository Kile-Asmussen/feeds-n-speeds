--! data: change crafting times of intermediate products
local times = {
    ['engine-unit']         = 5.0,
    ['electric-engine-unit'] = 5.0,
}

for recipe_name, energy_required in pairs(times) do
    local recipe = data.raw.recipe[recipe_name]
    if recipe then
        recipe.energy_required = energy_required
    else
        die("no such recipe: " .. recipe_name)
    end
end
