local utils = require('namespace')('utils')

local table = _ENV.table
local assert = _ENV.assert
local string = _ENV.string
local math = _ENV.math

function utils.tableindex(value, first)
    if type(value) ~= 'string' then
        return "[" .. tostring(value) .. "]"
    end

    if string.match(value, '^%s*[a-zA-Z_][a-zA-Z_0-9]*%s*$') then
        if first then
            return value
        else
            return '.' .. value
        end
    else
        return '[' .. string.format('%q', value) .. ']'
    end
end

function utils.tablepath(base, path)
    base = base or ''
    assert(type(path) == 'table', "argument #2 must be a table")
    local res = { tostring(base) }
    if path ~= nil then
        for _, v in ipairs(path) do
            table.insert(res, utils.tableindex(v))
        end
    end
    return table.concat(res)
end

function utils.null(...) return nil end

function utils.call(...)
    local args = { ... }
    return function(thing)
        for i = 1, #args do
            thing = args[i](thing)
        end
        return thing
    end
end

local __env_utils = _ENV.utils

function utils.use()
    rawset(_ENV, 'utils', utils)
end

function utils.restore()
    rawset(_ENV, 'utils', nil)
end

return utils:seal()