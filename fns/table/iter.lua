
return function(table, fns)
    local assert = fns.assert

    local pairs = table.pairs
    local ipairs = table.ipairs
    local type = fns.type

    local function mapper(func)
        if type(func) == 'table' then
            return function(k) return func[k] end
        else
            return func
        end
    end

    local function_or_table = { ['function'] = true, table = true }

    function table.imap(tbl, func)
        func = mapper(func)
        for i = 1, #tbl do
            tbl[i] = func(tbl[i], i)
        end
        return tbl
    end
    table.declare_twoarg('imap', function_or_table)

    function table.map(tbl, func)
        func = mapper(func)
        for k, v in pairs(tbl) do
            tbl[k] = func(v, k)
        end
        return tbl
    end
    table.declare_twoarg('map', function_or_table)

    function table.project(tbl, func)
        local res = {}
        for k, v in pairs(tbl) do
            local k_, v_ = func(k, v)
            if k_ ~= nil then res[k_] = v_ end
        end
        return res
    end
    table.declare_twoarg('project', 'function')

    function table.collect(tbl, thing)
        local func = thing
        if type(thing) == 'table' then func = function(k) return thing[k] end end
        local res = {}
        for k, v in pairs(tbl) do
            res[k] = func(v)
        end
        return res
    end
    table.declare_twoarg('collect', function_or_table)

    local insert = table.insert
    function table.icollect(tbl, thing)
        local func = thing
        if type(thing) == 'table' then func = function(k) return thing[k] end end
        local res = {}
        local n = 1
        for i = 1, #tbl do
            insert(res, func(tbl[i]))
        end
        return res
    end
    table.declare_twoarg('icollect',  function_or_table)

    local function opairs_iter(state)
        state.i = state.i + 1
        local key = state.keys[state.i]
        if key then 
            return key, state.tbl[key]
        end
    end

    function table.opairs(tbl, mapper)
        mapper = mapper or {}
        assert(type(tbl) == 'table', "fns.table.opairs: argument #1 must be a table")
        assert(type(mapper) == 'table', "fns.table.opairs: argument #1 must be a table")
        return opairs_iter, { i=0, keys=table.sorted_keys(tbl, mapper), tbl=tbl }, nil
    end

end