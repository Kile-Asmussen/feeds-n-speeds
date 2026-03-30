function table.new(res)
    if res == nil then
        res = {}
    end
    setmetatable(res, _G.table.__table_mt)
    return res
end

function table.descend(tbl, keys, ...)
    if type(keys) == 'string' then
        keys = table.pack(keys, ...)
    end
    
    for _, key in ipairs(keys) do
        if type(tbl) ~= 'table' then
            return nil
        end
        tbl = tbl[key]
    end
    return tbl
end

table.__table_mt = {
    __index = _G.table,
    __newindex = function(table, k, v)
        if _G.table[k] then
            error("Don't overwrite method names")
        end
        table.rawset(table, k, v)
    end,
}

function table.unmeta(self)
    setmetatable(self, nil)
end

function table.remove_matching(array, predicate)

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

function table.find_matching(array, predicate)
    for _, e in ipairs(array) do
        if predicate(e) then
            return e
        end
    end
end

table.rawget = rawget
table.rawset = rawset
table.pairs = pairs
table.ipairs = ipairs

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