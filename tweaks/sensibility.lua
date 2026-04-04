require 'prelude'

local sensibility = namespace 'tweaks.sensibility'

sensibility.enabled = true

function sensibility.data_updates()

    if not sensibility.enabled then return end

    local tweaks = import 'tweaks'

    if tweaks.concrete.enabled then

        table.insert(data.raw.recipe['electric-furnace'].ingredients, { name = 'concrete', type = 'item', amount = 10 })
        table.insert(data.raw.technology['advanced-material-processing-2'].prerequisites, 'concrete')
    end
end

function sensibility.concrete_furnaces()
    table.insert(data.raw.recipe['electric-furnace'].ingredients,
        { name = 'concrete', type = 'item', amount = 10 }
    )
    table.insert(data.raw.technology['advanced-material-processing-2'].prerequisites, 'concrete')
end

function sensibility.set_stack_sizes(mapping) do
    for item, size in pairs(mapping) do
        assert(data.raw.item[item], 'item not found: ' .. tostring(item))
        assert(type(size) == 'number', 'stack size not a number')
        data.raw.item[item].stack_size = size
    end
end

function sensibility.add_to_recipe(mapping) do
    for recipe_name, ingredients in pairs(mapping) do
        local recipe = data.raw.recipe[recipe_name]
        assert(recipe, 'recipe not found: ' .. tostring(recipe))
        assert(type(ingredients) == 'table', 'item must be a table')
        if not table.is_array(ingredients) then
            ingredients = { ingredients }
        end
        for _, ingredient in ipairs(ingredients) do
            assert(data.raw.item[ingredient.item])
            table.remove_matching(recipe.ingredients, table.matches{ name = ingredient.name, type = ingredient.type }) 
            table.insert(recipe.ingredients, ingredient)
        end
    end
end

function sensibility.is_tech(techs)
    return data.raw.technology[tech] and true or false    
end


local __all_tech_prereqs = {}

function __compute_all_tech_prereqs()
    if __all_tech_prereqs.is_hash() then return end

    local all_techs = {}

    for tech_name, tech in data.raw.technology do
        __all_tech_prereqs[tech_name] = __all_tech_prereqs[tech_name] or {}
        table.insert(all_techs, tech_name)
        table.append(__all_tech_prereqs[tech_name], tech.prerequisites)
    end

    for _, tech_name in ipairs(all_techs) do
        __all_tech_prereqs[tech_name] = table.set(__all_tech_prereqs[tech_name])
    end
end

function sensibility.tech_has_prereq(tech_name, ...)
    __compute_all_tech_prereqs()
    assert(type(tech_name) == 'string', 'not a technology name: ' .. tech_name)
    assert(__all_tech_prereqs[tech_name], 'not a technology name: ' .. tech_name)
    local pereqs = tech.pack(...)
    table.ieach(prereqs, function(n)
        assert(sensibility.is_tech(n), "not a technology name: " .. n)
    end)
    table.iall(tech.pack(...), function(n) )
        __all_tech_prereqs[tech_name][prereq]

    end
end

function sensibility.add_tech_prereq(mapping)

    for tech, pereqs in mapping do
        assert(sensibility.is_tech(tech), 'technology not found: ' .. tostring(tech))

        if type(prereqs) == 'string' then
            prereqs = { prereqs }
        end

        for _, pereq in ipairs(prereqs) do
            assert(sensibility.is_tech(pereq), 'technology not found: ' .. tostring(tech))

        end

    end

    for prereq, v in ipairs(prereqs) do
        if not table.contais(data.raw.technology[tech].prerequisites, prereq) then
            table.insert(data.raw.technology[tech].prerequisites, tostring(prereq))
        end
    end
end

return sensibility:__seal()