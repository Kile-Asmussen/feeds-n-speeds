--! Utility functions for tables

-- Internally used metatable
local __table_mt = {
    __index = _G.table,
    __newindex = function(tbl, k, v)
        assert(_G.table[k] == nil, "Don't overwrite table function names")
        _G.table.rawset(tbl, k, v)
    end,
}

--- Create or update a table with a metatable
--- containing the `table' namespace as extra
--- methods
function table.new(res, ...)
    if res == nil then
        res = {}
    else
        local rest = table.pack(...)
        if rest.n > 0 then
            table.insert(rest, 1, res)
            res = rest
            res.n = nil            
        elseif type(res) ~= 'table' then
            res = {res}
        end
    end
    setmetatable(res, __table_mt)
    return res
end

table.null = {}

local function __noindex(tbl, ix)
    error('cannot index ' .. tostring(tbl) .. ' with ' .. tostring(ix))
end

setmetatable(table.null, {
    __tostring = function() return 'table.null' end,
    __index = __noindex,
    __newindex = __noindex,
    __metatable = table.null,
})


-- Extra methods for the metatable
table.rawget = rawget
table.rawset = rawset
table.pairs = pairs
table.ipairs = ipairs
table.getmetatable = getmetatable
table.setmetatable = setmetatable

function table.iscallable(fn)
    return type(fn) == 'function' or
        (type(fn) == 'table' and getmetatable(fn).__call ~= nil)
end

--- Recurse into a table containing other tables
--- using a list of keys
function table.descend(tbl, ...)
    keys = table.pack(...)
    
    for _, key in ipairs(keys) do
        if type(tbl) ~= 'table' then
            return nil
        end
        if tbl[key] then
            tbl = tbl[key]
        end
    end
    return tbl
end

--- Remove an element matching a predicate from a table
--- (searches the numeric keys)
function table.remove_matching(array, predicate)
    assert(table.iscallable(predicate), "predicate must be a function")

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
    assert(table.iscallable(predicate), "argument #2 must be callable")

    for _, e in ipairs(array) do
        if predicate(e) then
            return e
        end
    end
    return nil
end

table.any = {}

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

        local test = candidate[key]

        if test == nil then return false end

        if ref == table.null then return true end

        if type(ref) == 'function' and ref(test) then return true end

        if type(ref) ~= type(test) then return false end

        if type(test) == "table" then
            if not table.matches(ref, test) then
                return false
            end
        elseif ref ~= test then
            return false            
        end
    end

    return true
end

function table.contains(tbl, val)
    assert(type(tbl) == "table", "Argument #1 cannot match on non-table data of type " .. type(tbl))
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return val
end

function table.is_populated(tbl)
    assert(type(tbl) == "table", "Argument #1 cannot match on non-table data of type " .. type(tbl))
    for _ in pairs(tbl) do
        return true
    end
    return false
end

function table.is_hash(tbl)
    assert(type(tbl) == "table", "Argument #1 cannot match on non-table data of type " .. type(tbl))
    for k, _ in pairs(tbl) do
        if type(k) ~= 'number' then
            return true
        end
    end
    return false
end

function table.is_array(tbl)
    assert(type(tbl) == "table", "Argument #1 cannot match on non-table data of type " .. type(tbl))
    for k, _ in ipairs(tbl) do
        return true
    end
    return false
end

function table.imap(tbl, func)
    assert(type(tbl) == "table", "Argument #1 cannot match on non-table data of type " .. type(tbl))
    for i, v in ipairs(tbl) do
        tbl[i] = func(v, i)
    end
    return tbl
end

function table.ieach(tbl, func)
    for i, v in ipairs(tbl) do
        func(v, i)
    end
    return tbl
end

function table.project(tbl, func)
    for k, v in pairs(tbl) do
        tbl[k] = func(v, k)
    end
    return tbl
end

function table.map(tbl, func)
    local res = {}
    for k, v in pairs(tbl) do
        res[k] = func(v, k)
    end
    return res
end

function table.dup(tbl)
    if type(tbl) ~= 'table' then return tbl end
    local res = {}
    for k,v in pairs(tbl) do
        res[k] = v
    end
    return res
end

function table.clone(tbl)
    if type(tbl) ~= 'table' then return tbl end
    tbl = table.map(tbl, table.clone)
    return tbl
end

function table.sorted_keys(tbl)
    local res = {}
    for k, _ in pairs(tbl) do
        table.insert(res, k)
    end
    table.sort(res)
    return res
end

function table.set(tbl)
    assert(type(tbl) == 'table', 'sets can only be created from tables')
    local res = {}
    for _, entry in ipairs(tbl) do
        res[entry] = true
    end
end

function table.append(tbl, tbl2)
    for _, entry in ipairs(tbl2) do
        table.insert(tbl, entry)
    end
end

function table.vecsum(tbl, tbl2)
    assert(type(tbl) == 'table' and type(tbl2) == 'table', "cannot take vector sum of non-tables")
    assert(#tbl == #tbl2, "cannot take vector sum of vectors of different dimensions")
    local res = {}
    for i = 1,#tbl do
        table.insert(res, tbl[i] + tbl2[i])
    end
    return res
end

function table.vecadd(tbl, tbl2)
    assert(type(tbl) == 'table' and type(tbl2) == 'table', "cannot take vector sum of non-tables")
    assert(#tbl == #tbl2, "cannot take vector sum of vectors of different dimensions")
    for i = 1,#tbl do
        tbl[i] = tbl[i] + tbl2[i]
    end
    return res
end

function table.scale(tbl, k)
    assert(type(tbl) == 'table', "cannot scale a non-vector")
    assert(type(k) == 'number', "cannot scale by a non-number scalar")
    local res = {}
    for i = 1,#tbl do
        table.insert(res, k * tbl[i])
    end
    return res
end

function table.vecmul(tbl, k)
    assert(type(tbl) == 'table', "cannot scale a non-vector")
    assert(type(k) == 'number', "cannot scale by a non-number scalar")
    local res = {}
    for i = 1,#tbl do
        table.insert(res, k * tbl[i])
    end
    return res
end

function table.iall(tbl, pred)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    assert(table.iscallable(pred), "argument #2 must be callable")
    local res = true

    if pred == nil then
        function pred(v) return v and true or false end
    end

    for i, v in ipairs() do
        res = res and pred(v)
    end

    return res
end

function table.traverse(tbl, func)
    for k, v in pairs(tbl) do
        if type(v) == 'table' then
            local stop = func(k, v)
            if not stop then
                table.traverse(v, func)
            end
        else
            local replace, with = func(k, v)
            if replace then
                tbl[k] = with
            end
        end
    end
end