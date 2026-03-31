--! Utility functions for tables

--- Create or update a table with a metatable
--- containing the `table' namespace as extra
--- methods
function table.new(res)
    if res == nil then
        res = {}
    end
    setmetatable(res, _G.table.__table_mt)
    return res
end

-- Internally used metatable
table.__table_mt = {
    __index = _G.table,
    __newindex = function(table, k, v)
        if _G.table[k] then
            error("Don't overwrite method names")
        end
        table.rawset(table, k, v)
    end,
}

-- Extra methods for the metatable
table.rawget = rawget
table.get = rawget
table.rawset = rawset
table.set = rawset
table.pairs = pairs
table.ipairs = ipairs

--- Recurse into a table containing other tables
--- using a list of keys
function table.descend(tbl, ...)
    keys = table.pack(...)
    
    for _, key in ipairs(keys) do
        if type(tbl) ~= 'table' then
            return nil
        end
        tbl = tbl[key]
    end
    return tbl
end

--- Remove the metatable from a table
function table.raw(self)
    setmetatable(self, nil)
end

--- Remove an element matching a predicate from a table
--- (searches the numeric keys)
function table.remove_matching(array, predicate)
    assert(type(predicate) == 'function', "predicate must be a function")

    local index = 0

    for i, e in ipairs(array) do
        if predicate(e) then
            index = i
            break
        end
    end

    if index == 0 then return end

    value = array[index]

    table.remove(array, index)

    return value
end

--- Find an element matching a predicate among the numeric keys
function table.find_matching(array, predicate)
    assert(type(array) == 'table', "argument #1 must be a table")
    assert(type(predicate) == 'function', "argument #2 must be a function")
    for _, e in ipairs(array) do
        if predicate(e) then
            return e
        end
    end
    return nil
end


--- Check if a reference table contains the same keys and elements
--- as a candidate table. If candidate is not given, returns a predicate function instead.
function table.matches(reference, candidate)
    assert(type(reference) == "table", "Cannot match on non-table data of type " .. type(reference))

    if candidate == nil then
        return function(candidate)
            if candidate == nil then return false end
            return table.matches(reference, candidate)
        end
    end

    if type(candidate) ~= "table" then return false end

    for key, ref in pairs(reference) do

        test = candidate[key]

        if test == nil then return false end

        if type(ref) ~= type(test) then return false end

        if type(test) == "table" then
            if not utils.matches(ref, test) then
                return false
            end
        elseif ref ~= test then
            return false            
        end
    end

    return true
end

function table.is_populated(tbl)
    for _ in pairs(tbl) do
        return true
    end
    return false
end