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
    'data-update-prototypes',
    'data-update-edits',
    'control',
}

modules:require 'construction'
modules:require 'integrations'
modules:require 'production'
modules:require 'bootstrap'
modules:require 'military'
modules:require 'logistics'
modules:require 'utilities'

function modules.load_stage(stage)

    assert(modules.stages[stage], "not a valid stage: " .. stage)

    local deps = modules.stage_dependencies(stage)

    deps = modules.order_dependencies(deps)

    for _, dep in ipairs(deps) do 
        require(dep)
    end
end

function modules.name(mod, name)
    if string.startswith(name, '.') then
        return tostring(mod) .. name
    else
        return name
    end
end

function modules.stage_dependencies(stage)
    local dependencies = {}

    for _, mod in table.opairs(modules) do
        if namespace.is(mod) and mod/stage then

            for name, deps in table.opairs(mod[stage]) do
                name = modules.name(mod, name)

                if type(deps) == 'table' then
                    for dep, val in table.opairs(deps) do
                        
                        assert(type(val) == 'boolean', 'dependencies of a component '
                            .. 'may not themselves have dependencies: ' .. fns.utils.tablepath(mod, { stage, dep }))

                        local depname = modules.name(mod, dep)

                        dependencies[name] = dependencies[name] or {}
                        dependencies[name][depname] = val
                    end
                else
                    dependencies[name] = deps
                end
            end
        end
    end

    return dependencies
end

local debuglib = require 'debuglib'

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
        if deps == true then deps = 0 end
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
            if table.all(deps, function(_, dep) return priorities[dep] end) then
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

    return order
end

return modules:seal(true)