return function(fns)

    fns.utils = require('namespace')('utils')
    local utils = fns.utils

    local table = fns.table
    local assert = fns.assert
    local string = fns.string
    local math = fns.math
    local type = fns.type

    function utils.tableindex(value, first)
        if type(value) ~= 'string' then
            return "[" .. string.tostring(value) .. "]"
        end

        if value:match('^%s*[a-zA-Z_][a-zA-Z_0-9]*%s*$') then
            if first then
                return value
            else
                return '.' .. value
            end
        else
            return '[' .. ("%q"):format(value) .. ']'
        end
    end

    function utils.tablepath(base, path)
        assert(type(path) == 'table', "argument #2 must be a table")
        local res = base ~= nil and { tostring(base) } or {}
        if path ~= nil then
            for _, v in ipairs(path) do
                table.insert(res, utils.tableindex(v))
            end
        end
        res = table.concat(res)
        if base == nil and res:startswith('.') then res = res:sub(2) end
        return res
    end

    function utils.null(...) return nil end

    function utils.exists(x) return x ~= nil end

    function utils.eq(x) return function(y) return x == y end end

    function utils.is_a(t) return function(x) return type(x) == t end end

    function utils.call(...)
        local args = { ... }
        return function(thing)
            for i = 1, #args do
                thing = args[i](thing)
            end
            return thing
        end
    end
    
    utils:seal()
end