
local gadget = require 'gadgets'
local debuglib = require 'debuglib'
local remove = {}
local unlocks = {}

for _, recipe in table.opairs(data.raw.recipe) do
    if recipe.auto_unlocked_by == nil then goto continue end

    local unlock = {}

    remove[recipe.name] = true

    if recipe.hidden then goto continue end

    if type(recipe.auto_unlocked_by) == 'table' then
        unlock = table.set(recipe.auto_unlocked_by)
    elseif type(recipe.auto_unlocked_by) == 'string' then
        unlock = { [recipe.auto_unlocked_by] = true }
    else
        error("recipe " .. recipe.name .. " can't be unlocked by " .. tostring(recipe.auto_unlocked_by), 1)
    end

    if table.is_empty(unlock) then
        recipe.enabled = true
    else
        recipe.enabled = false
        unlocks[recipe.name] = unlock
    end

    ::continue::
end

for _, tech in pairs(data.raw.technology) do
    if not tech.effects then goto continue end
    for i = #tech.effects, 1, -1 do
        if
            tech.effects[i].type == 'unlock-recipe' and
            remove[tech.effects[i].recipe]
        then
            table.remove(tech.effects, i)
        end
    end
    ::continue::
end

for recipe, unlock in table.opairs(unlocks) do
    for tech, _ in table.opairs(unlock) do
        if not data.raw.technology[tech] then
            error('no such technology: ' .. tech, 1)
        end

        data.raw.technology[tech].effects = data.raw.technology[tech].effects or {}

        table.insert(data.raw.technology[tech].effects, { type='unlock-recipe', recipe=unlock.__recipe })
    end
end