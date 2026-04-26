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

local function __noindex(tbl, ix)
    error('cannot index ' .. tostring(tbl) .. ' with ' .. tostring(ix))
end

local function __nonewindex(tbl, ix, val)
    error('cannot add index to ' .. tostring(tbl))
end

setmetatable(table.null, {
    __tostring = function() return 'table.null' end,
    __newindex = __nonewindex,
    __metatable = table.null,
})

function table.iscallable(fn)
    return type(fn) == 'function' or
        (type(fn) == 'table' and type(getmetatable(fn)) == 'table' and getmetatable(fn).__call ~= nil)
end

--- Recurse into a table containing other tables
--- using a list of keys
function table.descend(tbl, ...)
    keys = table.pack(...)
    
    for _, key in ipairs(keys) do
        if type(tbl) ~= 'table' then
            return tbl, false
        end

        if tbl[key] then
            tbl = tbl[key]
        else
            return tbl, false
        end
    end
    
    return tbl, true
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

function table.sorted_keys(tbl, only)
    local res = {}
    assert(only == nil or type(only) == 'string', 'argument #2 (optional) must be a string')
    if only then
        for k, _ in pairs(tbl) do
            if type(k) == only then
                table.insert(res, k)
            end
        end
    else
        for k, _ in pairs(tbl) do
            table.insert(res, k)
        end
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
    return res
end

function table.append(tbl1, tbl2)
    assert(type(tbl1) == 'table', "argument #1 must be a table")
    assert(type(tbl2) == 'table', "argument #2 must be a table")
    for _, entry in ipairs(tbl2) do
        table.insert(tbl1, entry)
    end
end

function table.add(tbl, tbl2)
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
    return tbl
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
    for i = 1,#tbl do
        tbl[i] = tbl[i] * k
    end
    return tbl
end

function table.sum(tbl, res)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    res = res or 0

    for _, n in ipairs(tbl) do
        res = res + n
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

    for i, v in ipairs(tbl) do
        res = res and pred(v)
    end

    return res
end

function table.traverse(tbl, func)
    for k, v in pairs(tbl) do
        if type(v) == 'table' then
            local stop = func(v, k)
            if not stop then
                table.traverse(v, func)
            end
        else
            local replace = func(v, k)
            if replace then
                tbl[k] = replace
            end
        end
    end
end

function table.isvec(tbl)
    return type(tbl) == 'table' and #tbl == 2 and type(tbl[1]) == 'number' and type(tbl[2]) == 'number'
end

local __proxy_mt = {
    __newindex = function(tbl, key, val)
        tbl.__real[key] = val
        newpath = {}
        table.append(newpath, tbl.__path)
        table.insert(newpath, key)
        tbl.__changes[tbl.__rootname .. string.tablepath(tbl.path)] = val
    end,

    __index = function(tbl, name)
        local val = tbl.__real[name]
        if type(val) == 'table' then
            newpath = {}
            table.append(newpath, tbl.__path)
            table.insert(newpath, name)
            return table.proxy{tbl=val, rootname=tbl.__rootname, root=tbl.__root, path=newpath, changes=tbl.__changes}
        else
            return val
        end
    end,

    __pairs = function(tbl)
        local k = nil
        return function()
            k = next(tbl.__real, k)
            if k then
                return k, tbl[k]
            end
        end
    end,

    __ipairs = function(tbl)
        local i = 0
        return function()
            i = i + 1
            if i <= #tbl then
                return i, tbl[i]
            end
        end
    end,

    __len = function(tbl)
        return #tbl.__real
    end,

    __tostring = function(tbl)
        return tbl.__base .. string.tablepath(tbl.__path) .. '<' .. tostring(tbl.__real) .. '>'
    end,

    __metatable = "__proxy_mt"
}

function table.proxy(args)
    assert(type(args) ~= "table", "table.proxy expects a table with five keys: tbl, [rootname, root, path, changes]")
    assert(type(args.tb) ~= "table", "table.proxy mandatory key tbl to be a table")
    args.rootname = args.rootname or tostring(args.tbl)
    args.root = args.root or args.tbl
    args.path = args.path or {}
    args.changes = args.changes or {}
    local res = {
        __real = args.tbl,
        __root = args.root,
        __rootname = args.rootname,
        __path = args.path,
        __changes = args.changes
    }
    setmetatable(res, __proxy_mt)
    return res
end