local fns = require 'fns'
local namespace = require 'namespace'
local modules = namespace 'modules'

local table = fns.table
local assert = fns.assert
local math = fns.math

local set = fns.table.intoset

modules.stages = set{
    'settings',
    'data',
    'data-updates',
    'control',
}

modules:require 'construction'
modules:require 'integrations'
modules:require 'production'
modules:require 'bootstrap'
modules:require 'military'
modules:require 'logistics'
modules:require 'utilities'

function modules.print_stage(stage)

    assert(modules.stages[stage], "not a valid stage: " .. stage)

    local components = modules.list_stage_components(stage)

    components = modules.order_dependencies(components)

    for _, comp in ipairs(components) do 
        print(("require %q"):format(comp))
    end
end

function modules.load_stage(stage)

    assert(modules.stages[stage], "not a valid stage: " .. stage)

    local components = modules.list_stage_components(stage)

    components = modules.order_dependencies(components)

    for _, comp in ipairs(components) do 
        require(comp)
    end
end

function modules.print_stage_loading_order(stage)

    assert(modules.stages[stage], "not a valid stage: " .. stage)

    local components = modules.list_stage_components(stage)
    local priorities

    components, priorities = modules.order_dependencies(components)

    for _, comp in ipairs(components) do
        print('require ' .. ("%q"):format(comp) .. " -- " .. priorities[comp])
    end
end

function modules.name(mod, name)
    if string.startswith(name, '.') then
        return tostring(mod) .. name
    else
        return name
    end
end

function modules.list_stage_components(stage)
    local dependencies = {}

    for _, mod in table.opairs(modules) do
        if namespace.is(mod) and mod/stage then

            for name, comp_deps in table.opairs(mod[stage]) do
                name = modules.name(mod, name)

                if type(comp_deps) == 'string' then
                    comp_deps = { [modules.name(comp_deps)] = true }
                elseif type(comp_deps) == 'table' then
                    local resolved = {}
                    for dep, val in table.opairs(comp_deps) do
                        resolved[modules.name(mod, dep)] = val and true or nil
                    end
                    dependencies[name] = resolved
                elseif type(comp_deps) == 'number' then
                    dependencies[name] = comp_deps
                elseif comp_deps then
                    dependencies[name] = 0
                end
            end
        end
    end

    return dependencies
end

function modules.order_dependencies(dependency_graph)
    assert(type(dependency_graph) == 'table', "argument #1 must be a table")

    dependency_graph = table.deepcopy(dependency_graph)

    local problems = {}

    for k, dep in table.opairs(dependency_graph) do
        if type(dep) == 'table' then
            for x, _ in table.opairs(dep) do
                if not dependency_graph[x] then
                    table.insert(problems, 'dependency ' .. k .. ' -> ' .. x .. ' does not exist')
                elseif x == k then
                    table.insert(problems, 'module ' .. k .. ' depends on itself')
                end
            end
        end
    end

    assert(#problems == 0, "not all dependencies can be fulfilled:\n" .. table.concat(problems, "\n"), 2)

    local priorities = {}

    for component, deps in table.opairs(dependency_graph) do
        if type(deps) == 'number' then
            dependency_graph[component] = nil
            priorities[component] = deps
        end
    end

    local progress = false
    while table.has_assoc(dependency_graph) do
        progress = false

        for component, deps in table.opairs(dependency_graph) do
            assert(type(deps) == 'table', "bad dependency in " .. component)
            if table.size(deps) == 0 then
                priorities[component] = 0
                dependency_graph[component] = nil
                progress = true
            elseif table.all(deps, function(_, dep) return priorities[dep] end) then
                local max_prio = math.find_max(table.icollect(table.sorted_keys(deps), table.index(priorities)))
                priorities[component] = max_prio + 1
                dependency_graph[component] = nil
                progress = true
            end
        end

        assert(progress, "no progress was made in dependency resolution")
    end

    local order = table.sorted_keys(priorities)

    table.sort(order, function(a, b)
        return priorities[a] < priorities[b]
    end)

    return order, priorities
end

return modules:seal(true)