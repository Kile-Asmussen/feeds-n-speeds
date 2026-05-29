
local table = _ENV.table
local assert = _ENV.assert

local function __mapper(func)
    if type(func) == 'table' then
        return function(k) return func[k] end
    else
        return func
    end
end

local __function_or_table = { ['function'] = true, table = true }

local function __imap(tbl, func)
    func = __mapper(func)
    for i, v in ipairs(tbl) do
        tbl[i] = func(v)
    end
    return tbl
end

table.imap = table.twoarg(__imap, __function_or_table)

local function __map(tbl, func)
    func = __mapper(func)
    for k, v in pairs(tbl) do
        tbl[k] = func(v)
    end
    return tbl
end
table.map = table.twoarg(__map, __function_or_table)

local function __project(tbl, func)
    local res = {}
    for k, v in pairs(tbl) do
        local k_, v_ = func(k, v)
        if k_ ~= nil then res[k_] = v_ end
    end
    return res
end
table.project = table.twoarg(__project, 'function')

local function __collect(tbl, thing)
    local func = thing
    if type(thing) == 'table' then func = function(k) return thing[k] end end
    local res = {}
    for k, v in pairs(tbl) do
        res[k] = func(v)
    end
    return res
end
table.collect = table.twoarg(__collect, __function_or_table)

local function __icollect(tbl, thing)
    local func = thing
    if type(thing) == 'table' then func = function(k) return thing[k] end end
    local res = {}
    for i, v in ipairs(tbl) do
        local v2 = func(v)
        if v2 ~= nil then
            table.insert(res, v2)
        end
    end
    return res
end
table.icollect = table.twoarg(__icollect, __function_or_table)

local function __opairs_iter(state, x)
    state.i = state.i + 1
    local key = state.keys[state.i]
    if key then 
        return key, state.tbl[key]
    end
end

function table.opairs(tbl, strings)
    return __opairs_iter, { i=0, keys=table.sorted_keys(tbl, 'string'), tbl=tbl }, nil
end
