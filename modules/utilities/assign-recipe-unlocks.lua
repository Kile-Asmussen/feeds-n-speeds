--! data-updates: find all recipes with auto_unlocked_by set, and update the tech tree to have those technologies unlock those recipes.
local fns = require 'fns'
local remove = {}
local unlocks = {}

local function malformed(recipe)
    error("malformed auto_unlocked_by on recipe " .. recipe.name, 2)
end

for _, recipe in table.opairs(data.raw.recipe) do
    if recipe.auto_unlocked_by == nil then goto continue end

    remove[recipe.name] = true

    if recipe.hidden then goto continue end

    local auto = recipe.auto_unlocked_by

    if type(auto) == 'string' then
        if auto == '' then
            recipe.enable = true
            goto continue
        end
        auto = { auto }
    end

    if type(auto) == 'table' and table.iall(auto, utils.is_a('string')) then

        if #auto == 0 then
            recipe.enabled = true
            goto continue
        else
            recipe.enabled = false
        end

         unlocks[recipe.name] = auto
    else
        malformed(recipe)
    end

    ::continue::
end

fns.gadgets.remove_unlocks(remove)

for recipe, unlock in table.opairs(unlocks) do
    for _, tech in ipairs(unlock) do

        if not data.raw.technology[tech] then
            error('no such technology: ' .. tech .. " on " .. recipe, 1)
        end

        data.raw.technology[tech].effects = data.raw.technology[tech].effects or {}

        local effect = table.include({ type='unlock-recipe', recipe=recipe }, table.dup_assoc(unlock))

        table.insert(data.raw.technology[tech].effects, effect)
    end
end