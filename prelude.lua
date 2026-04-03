require 'prelude.table'
require 'prelude.string'

local declared_namespaces = {}

local mod_identifiers = {}

function fns(name)
    name = name:gsub('%.', '-')
    name = name:gsub('_', '-')
    name = name:lower()
    local res = 'feeds-n-speeds-' .. name
    mod_identifiers[res] = true
    return res
end

function fns_identifiers()
    return table.sorted_keys(mod_identifiers)
end

_G.import = function(path)
    assert(declared_namespaces[path], 'no such namespace ' .. path)
    return declared_namespaces[path]
end

local function namespace(path)

    assert(not declared_namespaces[path], 'namespace '.. path .. ' already declared')

    local res = {
        __seal = function(self)
            self.__seal = nil
            getmetatable(self).__newindex = function(self, ...)
                error(path .. ' has been sealed')
            end
            getmetatable(self).__metatable = 'namespace'
            return self
        end,
        parent_namespace = table.null
    }

    declared_namespaces[path] = res

    local mt = {
        __tostring = function() return path end,
        __index = function(table, name) error(path .. '.' .. name .. ' not found') end,
        __newindex = function(table, name, value)
            assert(type(name) == 'string', 'namespace keys can only be strings')
            assert(value ~= nil, 'namespace values cannot be nil')
            if isnamespace(value) then
                value.parent_namespace = table
            end
            rawset(table, name, value)
        end,
        __call = function(table, name)
            assert(type(name) == 'string', 'namespace keys can only be strings')
            return rawget(table, name)
        end,
    }
    mt.__metatable = mt

    setmetatable(res, mt)
    return res
end

local function isnamespace(thing)
    if type(thing) ~= 'table' then return false end
    if getmetatable(thing) ~= 'namespace' then return false end
    return true
end

_G.import = import
_G.isnamespace = isnamespace
_G.namespace = namespace