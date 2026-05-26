
local tools = require 'gadgets'
local debuglib = require 'debuglib'
local remove = assoc{}
local unlocks = array{}

for _, recipe in opairs(data.raw.recipe) do
    if recipe.auto_unlocked_by == nil then goto continue end

    local unlock = {}

    remove[recipe.name] = true

    if recipe.hidden then goto continue end

    if
        type(recipe.auto_unlocked_by) == 'table' and
        #recipe.auto_unlocked_by >= 1 and
        table.iall(recipe.auto_unlocked_by, functions.is('string'))
    then
        unlock = table.set(recipe.auto_unlocked_by)
    elseif type(recipe.auto_unlocked_by) == 'string' then
        unlock = { [recipe.auto_unlocked_by] = true }
    else
        die("recipe " .. recipe.name .. " can't be unlocked by " .. tostring(recipe.auto_unlocked_by))
    end

    recipe.enabled = table.is_empty(unlock)

    if table.is_empty(unlock) then
        recipe.enabled = true
    else
        recipe.enabled = false
        unlocks[recipe.name] = unlock
    end

    ::continue::
end

tools.remove_unlock(remove)

for recipe, unlock in opairs(unlocks) do
    for tech, _ in opairs(unlock) do
        if not data.raw.technology[tech] then
            die('no such technology: ' .. tech)
        end

        table.insert(data.raw.technology[tech].effects, { type='unlock-recipe', recipe=unlock.__recipe })
    end
end