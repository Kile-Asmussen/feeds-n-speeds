
return function(table, fns)
    local assert = fns.assert
    local type = fns.type
    local pairs = fns.table.pairs
    local ipairs = fns.table.ipairs
    local select = fns.select
    local error = fns.error

    local function id(...) return ... end
    local function mapper(pred)
        if type(pred) == 'table' then
            return function(k) return pred[k] end
        elseif pred == nil then
            return id
        else
            return pred
        end
    end

    local quantify = {
        any = {
            kv = function(iter)
                return function(tbl, pred)
                    pred = mapper(pred)
                    for k, v in iter(tbl) do
                        if pred(k, v) then return true end
                    end return false
                end
            end,
            vk = function(iter)
                return function(tbl, pred)
                    pred = mapper(pred)
                    for k, v in iter(tbl) do
                        if pred(v, k) then return true end
                    end return false
                end
            end,
            k = function(iter)
                return function(tbl, pred)
                    pred = mapper(pred)
                    for k, v in iter(tbl) do
                        if pred(k) then return true end
                    end return false
                end
            end,
            v = function(iter)
                return function(tbl, pred)
                    pred = mapper(pred)
                    for k, v in iter(tbl) do
                        if pred(v) then return true end
                    end return false
                end
            end,
        },
        all = {
            kv = function(iter)
                return function(tbl, pred)
                    pred = mapper(pred)
                    for k, v in iter(tbl) do
                        if not pred(k, v) then return false end
                    end return true
                end
            end,
            vk = function(iter)
                return function(tbl, pred)
                    pred = mapper(pred)
                    for k, v in iter(tbl) do
                        if not pred(v, k) then return false end
                    end return true
                end
            end,
            k = function(iter)
                return function(tbl, pred)
                    pred = mapper(pred)
                    for k, v in iter(tbl) do
                        if not pred(k) then return false end
                    end return true
                end
            end,
            v = function(iter)
                return function(tbl, pred)
                    pred = mapper(pred)
                    for k, v in iter(tbl) do
                        if not pred(v) then return false end
                    end return true
                end
            end,
        }
    }

    table.iall = table.twoarg('function?', quantify.all.v(ipairs), 'iall')
    table.all = table.twoarg('function?', quantify.all.vk(pairs), 'all')
    table.iany = table.twoarg('function?', quantify.any.v(ipairs), 'iany')
    table.any = table.twoarg('function?', quantify.any.vk(pairs), 'any')

    function table.sorted_keys(tbl, mapping)
        assert(type(tbl) == 'table', "fns.table.sorted_keys: argument #1 must be a table")
        
        local mapper
        if type(mapping) == 'table' then
            mapper = function(ix) return mapping[ix] end
        elseif type(mapping) == 'function' then
            mapper = mapping
        elseif mapping == nil then
            mapper = function() end
        else
            error("fns.table.sorted_keys: argument #2 must be a table or function", 2)
        end

        local n = 1
        local res = {}

        for k, _ in pairs(tbl) do
            if type(k) == 'string' then
                res[n] = k
                n = n + 1
            else
                k = mapper(k)
                if type(k) == 'string' then
                    res[n] = k
                    n = n + 1
                end
            end
        end

        table.sort(res)

        return res
    end

    table.fullset = {}
    setmetatable(table.fullset, {
        __index = function() return true end,
        __newindex = function() error("table.fullset cannot be inserted into", 2) end,
        __metatable = "table.fullset",
    })

    table.emptyset = {}
    setmetatable(table.emptyset, {
        __index = function() return false end,
        __newindex = function() error("table.emptyset cannot be inserted into", 2) end,
        __metatable = "table.emptyset",
    })

    table.null = {}
    setmetatable(table.null, {
        __tostring = function() return "table.null" end,
        __newindex = function() error("table.null is immutable", 2) end,
        __metatable = "table.null",
    })

    function table.set(tbl)
        assert(type(tbl) == 'table', "argument #1 must be a table")
        local res = {}
        for _, entry in ipairs(tbl) do
            assert(entry ~= nil, "fns.table.set: nil key")
            res[entry] = true
        end
        return res
    end

    function table.intoset(tbl, ...)
        assert(type(tbl) == 'table', "argument #1 must be a table")
        local default = true
        if select('#', ...) >= 1 then
            default = ...
        end
        
        for i = #tbl, 1, -1 do
            local key = tbl[i]
            assert(key ~= nil, "fns.table.intoset: nil key")
            tbl[key] = default
            tbl[i] = nil
        end
        return tbl
    end
end