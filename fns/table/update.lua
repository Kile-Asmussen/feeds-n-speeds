
local table = _ENV.table
local assert = _ENV.assert

local function __overwrite(tbl1, tbl2)
    for k, v in pairs(tbl2) do
        tbl1[k] = v
    end

    return tbl1
end

local function __replace(tbl1, tbl2)
    for k, _ in pairs(tbl1) do
        if tbl2[k] ~= nil then
            tbl1[k] = tbl2[k]
        end
    end

    return tbl1
end

local function __include(tbl1, tbl2)
    for k, v in pairs(tbl2) do
        if tbl1[k] == nil then
            tbl1[k] = v
        end
    end

    return tbl1
end

local function __transmute(tbl1, tbl2)
    for k, _ in pairs(tbl1) do
        local func = tbl2[k]
        if func then
            tbl1[k] = func(tbl1)
        end
    end
end

local function __append(tbl1, tbl2)
    for i = 1, #tbl2 do
        table.insert(tbl1, tbl2[i])
    end
    return tbl1
end

local function __keep(tbl1, tbl2)
    for k, v in pairs(tbl1) do
        tbl1[k] = tbl2[k] and v or nil
    end
end

table.twoarg('keep', __keep)
table.twoarg('overwrite', __overwrite)
table.twoarg('replace', __replace)
table.twoarg('include', __include)
table.twoarg('transmute', __transmute)
table.twoarg('append', __append)

function table.cut(tbl, n)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    assert(type(n) == 'number', "argument #2 must be a number")
    while #tbl > n do
        table.remove(tbl)
    end
end

function table.flatten_keys(tbl)
    assert(type(tbl) == 'table', "argument #1 must be a table")
    local res = {}
    for k, v in pairs(tbl) do
        if type(k) == 'table' then
            for i = 1,#k do res[k[i]] = v end
        else
            res[k] = v
        end
    end
    return res
end

--- Merge tbl2 into tbl1
--- tlb2 and its subtables can have special keys
---
--- __rec : boolean?
--- if __rec is set to true, then merge all subtables instead of overwriting
--- despite the name 'rec' as in 'recursion', this does not propagate to subtables
--- it only applies for this single level
---
--- __merge : boolean?
--- if set in a sub-table will override the behavior of __rec set in the containing table
local function __merge(tbl1, tbl2)
    tbl2 = table.flatten_keys(tbl2)

    for k, v in pairs(tbl2) do
    
        if k == '__merge' or k == '__rec' then goto continue end
    
        local t = type(v)
    
        if t == 'function' then
            tbl1[k] = v(tbl1[k])
    
        elseif t == 'table' and type(tbl1[k]) == 'table' then

            if (tbl2.__rec or v.__merge == true) and v.__merge ~= false then
                __merge(tbl1[k], v)
            else
                tbl1[k] = v
            end
            
        else
            tbl1[k] = v
        end
    
        ::continue::
    end
    return tbl1
end
table.twoarg('merge', __merge)

-- maybe useful with functions that aren't made with twoarg?
function table.with(func, ...)
    assert(type(func) == "function", "argument #1 must be a function")
    local args = { ... }
    return function(val)
        assert(type(val) == "table", "argument #1 must be a table")
        return func(val, table.unpack(args))
    end
end