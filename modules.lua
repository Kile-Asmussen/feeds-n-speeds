
local namespace = require 'namespace'
local modules = namespace 'modules'

local set = table.intoset

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
        __log('# ' .. dep)
        local val = require(dep)
        if type(val) == 'table' or type(val) == 'function' then
            error('loading module ' .. dep .. ' returned a value of type ' .. type(val) .. ' which is probably unintentional', 2)
        end
    end
end

function modules.name(mod, name)
    string.replace_prefix(name, '^')
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
                        
                        assert(type(val) == 'boolean', 'dependencies of a module '
                            .. 'may not themselves have dependencies: ' .. utils.tablepath(mod, { stage, dep }))

                        local depname = modules.name(mod, dep)

                        if string.startswith(dep, '^') then
                            dependencies[depname] = dependencies[depname] or {}
                            dependencies[depname][name] = val
                        else
                            dependencies[name] = dependencies[name] or {}
                            dependencies[name][depname] = val
                        end
                    end
                else
                    dependencies[name] = true
                end
            end
        end
    end

    return dependencies
end

function modules.order_dependencies(dependencies)
    assert(type(dependencies) == 'table', "argument #1 must be a table")

    dependencies = table.clone(dependencies)

    local problems = {}

    for k, dep in table.opairs(dependencies) do
        if type(dep) == 'table' then
            for x, _ in table.opairs(dep) do
                if not dependencies[x] then
                    table.insert(problems, 'dependency ' .. k .. ' -> ' .. x .. ' does not exist')
                elseif x == k then
                    table.insert(problems, 'module ' .. k .. ' depends on itself')
                end
            end
        end
    end

    if #problems > 0 then
        error("not all dependencies can be fulfilled:\n" .. table.concat(problems, "\n"), 2)
    end

    local priorities = {}
    local order = {}
    local ordered = {}

    for k, deps in table.opairs(dependencies) do
        if deps == true then deps = 0 end

        if type(deps) == 'number' then
            ordered[k] = true
            dependencies[k] = nil
            priorities[k] = deps
            table.insert(order, k)           
        end
    end

    table.sort(order, function(a, b)
        if priorities[a] == priorities[b] then
            return a < b
        else
            return priorities[a] < priorities[b]
        end
    end)

    while table.has_assoc(dependencies) do
        for k, deps in table.opairs(dependencies) do
            if type(deps) == 'table' then
                for x, _ in table.opairs(deps) do
                    if ordered[x] then
                        deps[x] = nil
                    end
                end
                if table.is_empty(deps) then
                    table.insert(order, k)
                    ordered[k] = true
                    dependencies[k] = nil
                end
            else
                error("bad dependency: " .. tostring(dep) , 2)
            end
        end
    end

    return order
end

return modules:seal(true)