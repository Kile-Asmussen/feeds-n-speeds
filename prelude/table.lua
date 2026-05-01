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

setmetatable(table.null, {
    __tostring = function() return 'table.null' end,
    __index = function() end,
    __newindex = function() error("table.null is immutable") end,
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
    for k, v in pairs(tbl) do
        tbl[k] = func(v, k)
    end
    return tbl
end

function table.icollect(tbl, func)
    local res = {}
    for i, v in ipairs(tbl) do
        res[i] = func(v, i)
    end
    return res
end

function table.collect(tbl, func)
    local res = {}
    for k, v in pairs(tbl) do
        res[k] = func(v, k)
    end
    return res
end

function table.iany(tbl, func)
    func = func or function(x) return x end
    for i, v in ipairs(tbl) do
        if func(v, i) then return true end
    end
    return false
end

function table.any(tbl, func)
    func = func or function(x) return x end
    for k, v in pairs(tbl) do
        if func(v, k) then return true end
    end
    return false
end

function table.iall(tbl, func)
    func = func or function(x) return x end
    for i, v in ipairs(tbl) do
        if not func(v, i) then return false end
    end
    return true
end

function table.all(tbl, func)
    func = func or function(x) return x end
    for k, v in pairs(tbl) do
        if not func(v, k) then return false end
    end
    return true
end

function table.dup(tbl)
    if type(tbl) ~= 'table' then return tbl end
    return table.collect(tbl, function(x) return x end)
end

local function clone_with(seen)
    local function clone(tbl)
        if type(tbl) == 'table' then
            if not seen[tbl] then
                seen[tbl] = table.collect(tbl, clone)
            end
            return seen[tbl]
        else
            return tbl
        end
    end
    return clone
end

function table.clone(tbl)
    if type(tbl) ~= 'table' then return tbl end
    return clone_with({})(tbl)
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
    return tbl1
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
    return tbl
end

function table.vecscale(tbl, k)
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

function table.sum(tbl, res, map)
    assert(type(tbl) == 'table', "argument #1 must be a table")

    if type(res) == 'function' and map == nil then
        map = res
        res = nil
    end

    res = res or 0
    assert(type(res) == 'number', "argument #2 must be a number")

    local err =  "argument #1 must only contain numbers"
    if map then
        err =  "argument #1 must have all its elements map to numbers"
    end
    
    map = map or function(n) return n end
    assert(type(map) == 'function', "argument #3 must be a function")

    for _, n in ipairs(tbl) do
        n = map(n)
        assert(type(n) == 'number', err)
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

function table.cut(tbl, n)
    while #tbl > n do
        table.remove(tbl)
    end
end

local function __proxy_mt_newindex(tbl, key, val)
    tbl.__real[key] = val
    local newpath = {}
    table.append(newpath, tbl.__path)
    table.insert(newpath, key)
    local fullpath = string.tablepath(tbl.__rootname, newpath)
    table.cut(newpath, tbl.__maxdepth)
    local path = string.tablepath(tbl.__rootname, newpath)
    tbl.__hook(not tbl.__changes[path], path, fullpath, val)
    tbl.__changes[path] = true
end

local function __proxy_mt_index(tbl, name)
    local val = tbl.__real[name]
    if type(val) == 'table' then
        newpath = {}
        table.append(newpath, tbl.__path)
        table.insert(newpath, name)
        return table.proxy{
            tbl=val,
            rootname=tbl.__rootname,
            path=newpath,
            changes=tbl.__changes,
            hook=tbl.__hook,
            maxdepth=tbl.__maxdepth
        }
    else
        return val
    end
end

local function __proxy_mt_pairs(tbl)
    local k = nil
    return function()
        k = next(tbl.__real, k)
        if k then
            return k, tbl[k]
        end
    end
end

local function __proxy_mt_ipairs(tbl)
    local i = 0
    local n = #tbl
    return function()
        i = i + 1
        if i <= n then
            return i, tbl[i]
        end
    end
end

local function __proxy_mt_len(tbl)
    return #tbl.__real
end

local function __proxy_mt_tostring(tbl)
    return tbl.__rootname .. string.tablepath(tbl.__path) .. '=' .. tostring(tbl.__real)
end

local __proxy_mt = {
    __newindex = __proxy_mt_newindex,
    __index = __proxy_mt_index,

    __pairs = __proxy_mt_pairs,

    __ipairs = __proxy_mt_ipairs,

    __len = __proxy_mt_len,
    __tostring = __proxy_mt_tostring,

    __metatable = __proxy_mt
}

local print = _G.print
local function monkeypatch()
    print("monkeypatching table functions")
    local unpack = table.unpack
    function table.unpack(tbl)
        if getmetatable(tbl) == __proxy_mt then
            return unpack(tbl.__real)
        else
            return unpack(tbl) 
        end
    end

    local concat = table.concat
    function table.concat(tbl, ...)
        if getmetatable(tbl) == __proxy_mt then
            return concat(tbl.__real, ...)
        else
            return concat(tbl, ...) 
        end
    end

    local sort = table.sort
    function table.sort(tbl, ...)
        if getmetatable(tbl) == __proxy_mt then
            return sort(tbl.__real, ...)
        else
            return sort(tbl, ...) 
        end
    end

    local maxn = table.maxn
    function table.maxn(tbl, ...)
        if getmetatable(tbl) == __proxy_mt then
            maxn(tbl.__real, ...)
        else
            maxn(tbl, ...) 
        end
    end

    local insert = table.insert
    function table.insert(tbl, ...)
        if getmetatable(tbl) == __proxy_mt then
            return insert(tbl.__real, ...)
        else
            return insert(tbl, ...) 
        end
    end

    local remove = table.remove
        function table.remove(tbl, ...)
        if getmetatable(tbl) == __proxy_mt then
            return remove(tbl.__real, ...)
        else
            return remove(tbl, ...) 
        end
    end
    monkeypatch = function() end
end

function table.proxy(args)
    assert(type(args) == "table", "table.proxy expects a table with five keys: tbl, [rootname, path, changes]")
    assert(type(args.tbl) == "table", "table.proxy mandatory key tbl must be a table")
    monkeypatch()
    args.rootname = args.rootname or tostring(args.tbl)
    args.root = args.root or args.tbl
    args.path = args.path or {}
    args.hook = args.hook or function() end
    args.changes = args.changes or {}
    args.maxdepth = args.maxdepth or 1000

    assert(type(args.path) == "table",
        "table.proxy key path must be a table")

    assert(type(args.changes) == "table",
        "table.proxy key changes must be a table")

    assert(type(args.hook) == "function",
        "table.proxy key hook must be a function")

    assert(type(args.maxdepth) == "number",
        "table.proxy key maxdepth must be a number")

    local res = {
        __real = args.tbl,
        __rootname = args.rootname,
        __path = args.path,
        __hook = args.hook,
        __changes = args.changes,
        __maxdepth = args.maxdepth
    }
    setmetatable(res, __proxy_mt)
    return res
end