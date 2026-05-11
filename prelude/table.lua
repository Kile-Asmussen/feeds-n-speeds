--! Utility functions for tables

local setmetatable = _G.setmetatable
local getmetatable = _G.getmetatable

-- Extra methods for the metatable
table.rawget = rawget
table.rawset = rawset
table.pairs = pairs
table.ipairs = ipairs
table.getmetatable = getmetatable
table.setmetatable = setmetatable

table.null = {}

table.setmetatable(table.null, {
    __tostring = function() return 'table.null' end,
    __newindex = function() error("table.null is immutable") end,
    __metatable = table.null,
})

table.zero = {}

table.setmetatable(table.zero, {
    __tostring = function() return 'table.zero' end,
    __newindex = function() error("table.zero is immutable") end,
    __index = function() error("table.zero has no members") end,
    __metatable = table.zero,
})

require 'prelude.table.iter'
require 'prelude.table.match'
require 'prelude.table.proxy'
require 'prelude.table.sets'
require 'prelude.table.traverse'
require 'prelude.table.types'
require 'prelude.table.vectors'

function table.purgemetatable(tbl)
    table.traverse(tbl, function(t)
        if type(t) == 'table' then setmetatable(t, nil) end
    end)
end

function table.dup(tbl)
    if type(tbl) ~= 'table' then return tbl end
    return table.collect(tbl, functions.id)
end

function table.idup(tbl)
    if type(tbl) ~= 'table' then return tbl end
    return table.icollect(tbl, functions.id)
end

local function __clone(seen, setmeta)
    if setmeta then
        local function clone(tbl)
            if type(tbl) == 'table' then
                if not seen[tbl] then
                    seen[tbl] = table.collect(tbl, clone)
                    setmetatable(seen[tbl], getmetatable(tbl))
                    return seen[tbl]
                else
                    return tbl
                end
            else
                return tbl
            end
        end
        return clone
    else
        local function clone(tbl)
            if type(tbl) == 'table' then
                if not seen[tbl] then
                    seen[tbl] = table.collect(tbl, clone)
                    return seen[tbl]
                else
                    return tbl
                end
            else
                return tbl
            end
        end
        return clone
    end
end

function table.clone(tbl, setmeta)
    setmeta = setmeta and true or false
    if type(tbl) ~= 'table' then return tbl end
    return __clone({}, setmeta)(tbl)
end

function table.append(tbl1, tbl2)
    assert(type(tbl1) == 'table', "argument #1 must be a table")
    assert(type(tbl2) == 'table', "argument #2 must be a table")
    for i = 1, #tbl2 do
        table.insert(tbl1, tbl2[i])
    end
    return tbl1
end

function table.cut(tbl, n)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    assert(type(n) == 'number', "argument #2 must be a number")
    while #tbl > n do
        table.remove(tbl)
    end
end

function table.merge(tbl1, tbl2)
    assert(type(tbl1) == "table", "argument #1 must be a table")
    assert(type(tbl2) == "table", "argument #2 must be a table")

    for k, v in pairs(tbl2) do
        tbl1[k] = v
    end

    return tbl1
end

function table.soft_merge(conflict, tbl1, tbl2)
    assert(type(conflict) == "function", "argument #1 must be a function")
    assert(type(tbl1) == "table", "argument #2 must be a table")
    assert(type(tbl2) == "table", "argument #3 must be a table")

    for k, v in pairs(tbl2) do
        if tbl1[k] then
            tbl1[k] = conflict(tbl1[k], v, k)
        else
            tbl1[k] = v
        end
    end

    return tbl
end

function table.recursion_check(tbl, seen, path, base)
    seen = seen or {}
    path = path or {}
    base = base or '_'

    if type(tbl) ~= 'table' then
        return
    end

    tbl = table.unproxy(tbl)

    if seen[tbl] then
        error(seen[tbl] .. ' = ' .. string.tablepath(base, path))
    end

    seen[tbl] = string.tablepath(base, path)

    for k, v in pairs(tbl) do
        table.insert(path, k)
        table.recursion_check(v, seen, path, base)
        table.remove(path)
    end

    seen[tbl] = nil
end
