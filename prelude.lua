require 'prelude.table'
require 'prelude.string'

local function namespace(path)
    local res = {
        __seal = function(self)
            self.__seal = nil
            getmetatable(self).__newindex = function(self, ...)
                error(path .. ' has been sealed')
            end
            getmetatable(self).__metatable = 'namespace'
            return self
        end
    }

    local mt = {
        __tostring = function() return path end,
        __index = function(table, name) error(path .. '.' .. name .. ' not found') end,
        __newindex = function(table, name, value)
            if type(name) ~= 'string' then
                error('namespace keys can only be strings')
            end
            if value == nil then
                error('namespace values cannot be nil')
            end
            rawset(table, name, value)
        end,
        __call = function(table, name)
            if type(name) ~= 'string' then
                error('namespace keys can only be strings')
            end
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

_G.isnamespace = isnamespace
_G.namespace = namespace