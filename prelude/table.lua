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

--- Check if a reference table contains the same keys and elements
--- as a candidate table. If candidate is not given, returns a predicate function instead.
function table.matches(reference, ...)
    local n = select('#', ...)
    assert(n <= 1, "Too many arguments, expected 0 or 1")

    if n == 0 then
        return function(candidate)
            return table.matches(reference, candidate)
        end
    end

    local candidate = ...

    if type(reference) == 'function' then
        return reference(candidate)
    elseif type(reference) ~= 'table' then
        return reference == candidate
    end


    if type(candidate) ~= "table" then return nil end

    for key, ref in pairs(reference) do

        local test = candidate[key]

        if test == nil then return nil end

        if ref == table.null then return true end

        if type(ref) == 'function' and ref(test) then return true end

        if type(ref) ~= type(test) then return nil end

        if type(test) == "table" then
            if not table.matches(ref, test) then
                return nil
            end
        elseif ref ~= test then
            return nil            
        end
    end

    return true
end


function table.search(tbl, thing)
    if type(thing) ~= 'function' then
        thing = table.matches(thing)
    end

    if thing(tbl) then return tbl end

    if type(tbl) ~= 'table' then return nil end

    for k, v in pairs(tbl) do
        local found = table.search(v, thing)
        if found then return found end
    end

    return nil
end

--- Recurse into a table containing other tables
--- using a list of keys
function table.descend(tbl, ...)
    keys = table.pack(...)
    
    for _, key in ipairs(keys) do
        if type(tbl) ~= 'table' then
            return tbl, false
        end

        if tbl[key] ~= nil then
            tbl = tbl[key]
        else
            return tbl, false
        end
    end
    
    return tbl, true
end

function table.access(tbl, ...)
    keys = table.pack(...)
    
    for _, key in ipairs(keys) do
        if type(tbl) ~= 'table' then
            return nil
        end

        if tbl[key] ~= nil then
            tbl = tbl[key]
        else
            return nil
        end
    end
    
    return tbl
end

function table.index_of(array, thing)
    if type(thing) ~= 'function' then
        thing = table.matches(thing)
    end
    assert(type(array) == 'table', "argument #1 must be a table")

    local index = nil

    for i, e in ipairs(array) do
        if thing(e, i) then
            index = i
            break
        end
    end

    return index
end

--- Remove an element matching a predicate from a table
--- (searches the numeric keys)
function table.remove_matching(array, thing)
    if type(thing) ~= 'function' then
        thing = table.matches(thing)
    end
    assert(type(array) == 'table', "argument #1 must be a table")

    local ix = table.index_of(array, thing)
    if ix then 
        return table.remove(array, ix)
    else
        return nil
    end
end

--- Find an element matching a predicate/table pattern among the numeric keys
function table.find_matching(array, thing)
    if type(thing) ~= 'function' then
        thing = table.matches(thing)
    end
    assert(type(array) == 'table', "argument #1 must be a table, not " .. tostring(array))

    local ix = table.index_of(array, thing)
    if ix then 
        return array[ix]
    else
        return nil
    end
end

function table.is_empty(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return not next(tbl)
end

function table.has_array(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    return table.maxn(tbl) ~= 0
end

function table.is_assoc(tbl)
    if getmetatable(tbl) == table.__assoc_mt then return true end
    assert(type(tbl) == "table", "argument #1 must be a table")
    return table.is_empty(tbl) or not table.has_array(tbl)
end

function table.is_array(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if getmetatable(tbl) == table.__array_mt then return true end
    local k
    repeat
        k = next(tbl, k)
    until type(k) ~= 'number'
    return k == nil
end

function table.has_assoc(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local k
    repeat
        k = next(tbl, k)
    until type(k) ~= 'number' or k == nil
    return k ~= nil and type(k) ~= 'number'
end

function table.size(tbl)
    assert(type(tbl) == "table", "argument #1 must be a table")
    local k = next(tbl)
    local n = 0
    while k do
        n = n + 1
        k = next(tbl, k)
    end
    return n
end

function table.imap(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    for i, v in ipairs(tbl) do
        tbl[i] = func(v, i)
    end
    return tbl
end

function table.each(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    for i, v in ipairs(tbl) do
        func(v, i)
    end
    return tbl
end

function table.map(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(func) == "function", "argument #2 must be a function")
    for k, v in pairs(tbl) do
        tbl[k] = func(v, k)
    end
    return tbl
end

function table.map_pairs(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(func) == "function", "argument #2 must be a function")
    for k, v in pairs(tbl) do
        tbl[k] = func(k, v)
    end
    return tbl
end

function table.at(...)
    local args = table.pack(...)
    return function(tbl) return table.access(tbl, table.unpack(args)) end
end

function table.indexN(tbl)
    return function(...) return table.access(tbl, ...) end
end

function table.index(tbl)
    return function(i) return table[i] end
end

function table.collect(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if type(func) == 'table' then func = table.index(func) end
    assert(type(func) == "function", "argument #2 must be a function or table")
    local res = {}
    for k, v in pairs(tbl) do
        res[k] = func(v, k)
    end
    return res
end

function table.collect_pairs(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if type(func) == 'table' then func = table.index(func) end
    assert(type(func) == "function", "argument #2 must be a function or table")
    local res = {}
    for k, v in pairs(tbl) do
        res[k] = func(k, v)
    end
    return res
end

function table.icollect(tbl, func)
    assert(type(tbl) == "table", "argument #1 must be a table")
    if type(func) == 'table' then func = table.index(func) end
    assert(type(func) == "function", "argument #2 must be a function")
    local res = {}
    for i, v in ipairs(tbl) do
        local v2 = func(v, i)
        if v2 ~= nil then
            table.insert(res, v2)
        end
    end
    return res
end

function table.dup(tbl)
    if type(tbl) ~= 'table' then return tbl end
    return table.collect(tbl, functions.id)
end

local function clone_with(seen, setmeta)
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
    return clone_with({}, setmeta)(tbl)
end

function table.unsorted_keys(tbl)
    local res = {}
     for k, _ in pairs(tbl) do
        table.insert(res, k)
    end
    return res
end

local types = {
    string = true,
    number = true,
    boolean = true,
    table = true,
    userdata = true,
    coroutine = true,
    ['nil'] = true,
    ['function'] = true
}

function table.unsorted_keys_of(tbl, only)
    local res = {}
    assert(types[only], 'argument #2 must be the name of a type')
     for k, _ in pairs(tbl) do
        if type(k) == only then
            table.insert(res, k)
        end
    end
    return res
end

function table.sorted_keys(tbl)
    local res = table.unsorted_keys_of(tbl, 'string')
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

function table.asset(tbl, ...)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    local value = true
    if select('#', ...) == 1 then value = ... end

    if type(value) == 'function' then
        while #tbl > 0 do
            local ix = #tbl
            local key = table.remove(tbl)
            tbl[key] = value(ix)
        end
    else
        while #tbl > 0 do
            local key = table.remove(tbl)
            tbl[key] = value
        end
    end
    return table.assoc(tbl)
end

function table.append(tbl1, ...)
    local n = select('#', ...)
    assert(type(tbl1) == 'table', "argument #1 must be a table")
    for i = 1, n do
        local tbl2 = select(i, ...)
        assert(type(tbl2) == 'table', "argument #" .. (i+1) .. " must be a table")
        for _, entry in ipairs(tbl2) do
            table.insert(tbl1, entry)
        end
    end
    return tbl1
end

function table.merge(tbl, ...)
    local n = select('#', ...)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(n >= 1, "too few arguments")

    for i = 1, n do
        local tbl2 = select(i, ...)
        assert(type(tbl2) == "table", "argument #" .. (i+1) .. " must be a table")

        for k, v in pairs(tbl2) do
            tbl[k] = v
        end
    end

    return tbl
end

function table.soft_merge(conflict, tbl, ...)
    local n = select('#', ...)
    assert(type(conflict) == "function", "argument #1 must be a function")
    assert(type(tbl) == "table", "argument #2 must be a table")
    assert(n >= 1, "too few arguments")

    for i = 1, n do
        local tbl2 = select(i, ...)
        assert(type(tbl2) == "table", "argument #" .. (i+1) .. " must be a table")

        for k, v in pairs(tbl2) do
            if tbl[k] then
                tbl[k] = conflict(tbk[k], v, k)
            else
                tbl[k] = v
            end
        end
    end

    return tbl
end

function table.vecsum(tbl, tbl2, res)
    assert(type(tbl) == 'table' and type(tbl2) == 'table', "cannot take vector sum of non-tables")
    assert(#tbl == #tbl2, "cannot take vector sum of vectors of different dimensions")
    res = res and {} or tbl
    for i = 1,#tbl do
        res[i] = tbl[i] + tbl2[i]
    end
    return res
end

function table.vecmul(tbl, k, res)
    assert(type(tbl) == 'table', "cannot scale a non-vector")
    assert(type(k) == 'number', "cannot scale by a non-number scalar")
    res = res and {} or tbl
    for i = 1,#tbl do
        res[i] = tbl[i] * k
    end
    return res
end

function table.sum(tbl, res)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    res = res or 0
    assert(type(res) == 'number', "argument #2 must be a number")

    for _, n in ipairs(tbl) do
        n = map(n)
        assert(type(n) == 'number', "argument #1 must only contain numbers")
        res = res + n
    end

    return res
end

local function __all(iter, pred, kv)
    if kv then
        for k, v in iter do
            if not pred(k, v) then return false end
        end
    else
        for k, v in iter do
            if not pred(v, k) then return false end
        end
    end
    return true
end

local function __any(iter, tbl, pred, kv)
    if kv then
        for k, v in iter(tbl) do
            if not pred(k, v) then return true end
        end
    else
        for k, v in iter(tbl) do
            if not pred(v, k) then return true end
        end
    end
    return false
end

function table.all(tbl, pred)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    pred = pred or functions.id
    assert(type(pred) == 'function', "argument #2 must be a function if present")
    return __all(ipairs, tbl, pred)
end

function table.all_values(tbl, pred)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(pred) == "function", "argument #2 must be a function")
    return __any(pairs, tbl, pred)
end


function table.all_pairs(tbl, pred)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    swap = pred and true or false
    pred = pred or functions.id
    assert(type(pred) == 'function', "argument #2 must be a function if present")
    return __all(pairs, tbl, pred, swap)
end

function table.any(tbl, pred)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(pred) == "function", "argument #2 must be a function")
    return __any(ipairs, tbl, pred)
end

function table.any_values(tbl, pred)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(pred) == "function", "argument #2 must be a function")
    return __any(pairs, tbl, pred)
end

function table.any_pairs(tbl, pred)
    assert(type(tbl) == "table", "argument #1 must be a table")
    assert(type(pred) == "function", "argument #2 must be a function")
    return __any(pairs, tbl, pred, true)
end


function table.traverse(tbl, func)
    for k, v in pairs(tbl) do
        if type(v) == 'table' then
            local stop, replace = func(v, k)
            if replace then
                tbl[k] = stop
            elseif not stop then
                table.traverse(v, func)
            end
        else
            local value, replace = func(v, k)
            if replace then
                tbl[k] = value
            end
        end
    end
end

function table.replace(tbl, a, b)
  table.traverse(tbl, function(v)
    if a == v then
      return b, true
    end
  end)
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

local function __proxy_next(tbl, k)
    local k = next(tbl.__real, k)
    return k, tbl[k]
end

local function __proxy_mt_pairs(tbl)
    return __proxy_next, tbl, nil
end

local function __proxy_incr(tbl, i)
    if i <= #tbl.__real then
        i = i + 1
        return i, tbl[i]
    end
end

local function __proxy_mt_ipairs(tbl)
    return __proxy_incr, tbl, 0
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

local function monkeypatch()
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
    assert(type(args) == "table", "table.proxy expects a table with up to six keys: tbl, [rootname, path, hook, changes, maxdepth]")
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

function table.is_proxied(tbl)
    return getmetatable(tbl) == __proxy_mt
end

function table.unproxy(tbl)
    if table.is_proxied(tbl) then return tbl.__real else return tbl end
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


function table.max(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    local max = tbl[1]
    for _, n in ipairs(tbl) do
        max = math.max(max, n)
    end
    return max
end

function table.max_by(tbl, func)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    assert(type(func) == 'function', "argument #2 must be a function")
    local max, argmax = nil, nil
    for i, v in ipairs(tbl) do
        if func(max, v) then
            max = v
            argmax = i
        end
    end
    return max, argmax
end

function table.simple_sort(tbl, comp)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    assert(type(comp) == 'function', "argument #2 must be a function")

    local i = 2

    while i <= #tbl do
        if i == 2 or comp(tbl[i-1], tbl[i]) then
            i = i + 1
        else
            tbl[i], tbl[i-1] = tbl[i-1], tbl[i]
        end
    end

    return tbl
end

local function __array_newindex(tbl, i, v)
    assert(type(i) == 'number', "cannot insert non-numerical key into array")
    assert(math.floor(i) == i, "cannot insert non-integer key into array")
    assert(i >= 1, "cannot insert zero or negative key into array")
    rawset(tbl, i, v)
end

local function __assoc_pairs()
    error("cannot iterate pairs over table.assoc")
end

table.__array_mt = {
    __newindex = __array_newindex,
    __pairs = __assoc_pairs,
}

local function __assoc_newindex(tbl, k, v)
    assert(type(k) == 'string', "cannot insert non-string key into associative array")
    rawset(tbl, k, v)
end

local function __assoc_ipairs()
    error("cannot iterate ipairs over table.assoc")
end

table.__assoc_mt = {
    __newindex = __assoc_newindex,
    __ipairs = __assoc_ipairs,
}

if _G.TESTING then

    function table.array(tbl)
        tbl = tbl or {}
        assert(table.is_array(tbl), "non-array table passed to table.array")
        assert(not getmetatable(tbl), "already has a metatable")
        setmetatable(tbl, table.__array_mt)
        return tbl
    end

    function table.assoc(tbl)
        tbl = tbl or {}
        assert(table.is_assoc(tbl), "non-associative table passed to table.assoc")
        assert(not getmetatable(tbl), "already has a metatable")
        setmetatable(tbl, table.__array_mt)
        return tbl
    end

else

    function table.array(tbl)
        tbl = tbl or {}
        assert(table.is_array(tbl), "non-array table passed to table.array")
        return tbl
    end

    function table.assoc(tbl)
        tbl = tbl or {}
        assert(table.is_assoc(tbl), "non-associative table passed to table.assoc")
        return tbl
    end

end

function table.purgemetatable(tbl)
    table.traverse(tbl, function(t)
        if type(t) == 'table' then
            setmetatable(t, nil)
        end
    end)
end