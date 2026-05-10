require 'prelude'


local modules = namespace 'modules'

modules.__loaded = false
modules.military = table.null
modules.logistics = table.null
modules.bootstrap = table.null
modules.production = table.null
modules.construction = table.null
modules.utilities = table.null

function modules.load()
    if modules.__loaded then return end

    modules.__loaded = true
    modules.construction = require 'module.construction'
    modules.production = require 'module.production'
    modules.bootstrap = require 'module.bootstrap'
    modules.military = require 'module.military'
    modules.logistics = require 'module.logistics'
    modules.utilities = require 'module.utilities'

end

function modules.qualify(namespace, table)
    local qualified = {}
    for k, v in table do
        if v == true then v = table.null end
        qualified[tostring(namespace) .. '.' .. k] = v
    end
end

function modules.order(stage)
    local res = {}

    for _, mod in pairs(modules) do
        if isnamespace(mod) then
            table.merge(res,
                (mod / stage) or table.null
            )
        end
    end

    local ord = table.sorted_keys()
end

function modules.comparer(dependencies)
    return function(a, b)
        if dependencies[a][b] then return false end
        if dependencies[b][a] then return true end
        return a < b
    end
end

function modules.settings()
    modules.load()
end

function modules.data_prototypes()
    modules.load()
end

function modules.data_edits()
    modules.load()
end

function modules.data_updates()
    modules.load()
end


return seal_namespace(modules)