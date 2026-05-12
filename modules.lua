require 'prelude'

local modules = namespace 'modules'

modules.stages = asset{
    'settings',
    'data',
    'data-updates',
    'data-update-prototypes',
    'data-update-edits',
    'control',
}

modules:require 'construction'
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
        __log('')
        __log('# ' .. dep)
        local ok, val = pcall(require, dep)
        if not ok then
            die(val)
        elseif type(val) == 'table' or type(val) == 'function' then
            die('loading module ' .. dep .. ' returned a value of type ' .. type(val) .. ' which is probably unintentional')
        end
    end
end

function modules.name(mod, name)
    if name:sub(1, 1) == '.' then
        return tostring(mod) .. name
    else
        return name
    end
end

function modules.stage_dependencies(stage)
    local dependencies = assoc{}

    for k, mod in opairs(modules) do
        if isnamespace(mod) and rawget(mod, stage) then
            local name = tostring(mod)
            local deps = assoc{}
            
            for k, v in opairs(mod[stage]) do
                k = modules.name(mod, k)

                assert(not dependencies[k], 'name collission on ' .. k .. ' during ' .. stage)
                if type(v) == 'table' then
                    dependencies[k] = table.set(
                        table.icollect(
                            table.sorted_keys(v),
                            function(s) return modules.name(mod, s) end
                        )
                    )
                else
                    dependencies[k] = v
                end
            end
        end
    end

    return dependencies
end

function modules.order_dependencies(dependencies)
    assert(type(dependencies) == 'table', "argument #1 must be a table")

    dependencies = table.clone(dependencies)

    for k, dep in opairs(dependencies) do
        if type(dep) == 'table' then
            for x, _ in opairs(dep) do
                if not dependencies[x] then die('dependency ' .. k .. ' -> ' .. x .. ' does not exist') end
                if x == k then die('module ' .. k .. ' depends on itself') end
            end
        end
    end

    local order = array{}
    local ordered = assoc(table.set(order))

    while table.has_assoc(dependencies) do
        for k, deps in opairs(dependencies) do
            if deps == true or not table.has_assoc(deps) then
                ordered[k] = true
                dependencies[k] = nil
                table.insert(order, k)
            else
                for x, _ in opairs(deps) do
                    if ordered[x] then
                        deps[x] = nil
                    end
                end
            end
        end
    end

    return order
end

return modules:seal(true)