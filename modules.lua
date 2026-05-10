require 'prelude'


local modules = namespace 'modules'

modules.stages = asset{
    settings = array{ 'settings-prototypes', 'settings-edits' },
    'settings-prototypes',
    'settings-edits',
    data = array{ 'data-prototypes', 'data-edits' },
    'data-prototypes',
    'data-edits',
    ['data-updates'] = array{ 'data-update-prototypes', 'data-update-edits'},
    'data-update-prototypes',
    'data-update-edits',
    'control'
}

modules:require 'construction'
modules:require 'production'
modules:require 'bootstrap'
modules:require 'military'
modules:require 'logistics'
modules:require 'utilities'

function modules.stage_dependencies(stage)
    local dependencies = assoc{}

    for k, mod in pairs(modules) do
        if isnamespace(mod) and rawget(mod, stage) then
            local name = tostring(mod)
            local deps = assoc{}
            
            for k, v in pairs(mod[stage]) do
                k = name .. '.' .. k
                assert(not dependencies[k], 'name collission on ' .. k .. ' during ' .. stage)
                dependencies[k] = table.clone(v, true)
            end
        end
    end

    return dependencies
end

function modules.order_dependencies(dependencies)
    assert(type(dependencies) == 'table', "argument #1 must be a table")

    dependencies = table.clone(dependencies)

    for k, dep in pairs(dependencies) do
        if type(dep) == 'table' then
            for x, _ in pairs(dep) do
                assert(dependencies[x] or x == k, "unsatisfiable dependency: " .. k .. " -> " .. x)
            end
        end
    end

    local order = array{}
    local ordered = assoc(table.set(order))

    while table.has_assoc(dependencies) do
        for k, deps in pairs(dependencies) do
            if deps == true or not table.has_assoc(deps) then
                ordered[k] = true
                dependencies[k] = nil
                table.insert(order, k)
            else
                for x, _ in pairs(deps) do
                    if ordered[x] then
                        deps[x] = nil
                    end
                end
            end
        end
    end

    return order
end


local function load_stage(stage)
    assert(modules.stages[stage], "not a valid stage: " .. stage)

    local deps = modules.stage_dependencies(stage)
    
    deps = modules.order_dependencies(deps)

    local errors = false
    for _, dep in ipairs(deps) do 
        modules.handle_submodule(require(dep), dep, stage)
    end
end

function modules.load_stage(stage)
    if type(modules.stages[stage]) == 'table' then
        for _, s in ipairs(modules.stages[stage]) do
            load_stage(s)
        end
        load_stage(stage)
        return
    end
end

function modules.handle_submodule(submod, path, stage)
    if submod == nil then return end

    if isnamespace(submod) then

        if stage:match('prototype') then
            modules.handle_submodule(submod/'prototype', path .. '.prototype', stage)
        elseif stage:match('edit') then
            modules.handle_submodule(submod/'edit', path .. '.edit', stage)
        else
            modules.handle_submodule(submod/'load', path .. '.load', stage)
        end

    elseif type(submod) == 'table' then

        table.purgemetatable(submod)

        assert(not stage:match('edit'), "loading prototype " .. path .. ' during ' .. stage)

        assert(not table.is_empty(submod), "empty table from module " .. path)

        if table.is_array(submod) then
            data:extend(submod)
        elseif table.is_assoc(submod) then
            data:extend{submod}
        end

    elseif type(submod) == 'function' then

        assert(not stage:match('prototype'), "executing " .. path .. ' during ' .. stage)

        modules.handle_submodule(submod(), path, stage)

    else
        error('submods ' .. dep .. ' should be either a namespace, function or a table, got ' .. type(submod) .. ' - ' .. tostring(submod))
    end
end

return seal_namespace(modules)