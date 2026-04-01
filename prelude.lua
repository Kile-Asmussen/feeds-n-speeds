require 'prelude.table'
require 'prelude.string'

function namespace(path)
    local res = {
        __seal = function(self)
            self.__seal = nil
            getmetatable(self).__newindex = function(self, ...)
                error(path .. ' has been sealed')
            end
            getmetatable(self).__metatable = path
            return self
        end
    }

    setmetatable(res, {
        __tostring = function() return path end,
        __index = function(table, name) error(path .. '.' .. name .. ' not found') end,
        __newindex = function(table, name, value)
            if type(name) == 'number' then
                error('namespaces are not arrays')
            end
            rawset(table, name, value)
        end,
        __call = function(table, name)
            return rawget(table, name)
        end,
    })
    return res
end