
return function(table, fns)
    local assert = fns.assert
    local type = fns.type
    local pairs = table.pairs

    local function match(candidate, reference)

        if type(candidate) ~= 'table' then return nil end

        for key, ref in pairs(reference) do

            local can = candidate[key]

            if type(ref) == 'function' and not ref(can) then return nil end

            if can == nil then return nil end

            if type(ref) ~= type(can) then return nil end

            if type(can) == "table" then
                if match(can, ref) == nil then return nil end
            else
                if ref ~= can then return nil end
            end
        end

        return candidate
    end
    table.match = table.twoarg('any?', 'table', match, 'match')

    local function differs(candidate, reference)

        if type(candidate) ~= 'table' then return candidate end

        for key, ref in pairs(reference) do

            local can = candidate[key]

            if type(ref) == 'function' and not ref(can) then return candidate end

            if can == nil then return candidate end

            if type(ref) ~= type(can) then return candidate end

            if type(can) == "table" then
                if differs(can, ref) ~= nil then return candidate end
            else
                if ref ~= can then return candidate end
            end
        end

        return nil
    end

    table.differs = table.twoarg('any?', 'table', differs, 'differs')

    local function predicate(pred)
        if type(pred) == 'table' then
            return function(ix) return pred[ix] end
        elseif type(pred) ~= 'function' then
            return function(v) return v == pred end
        else
            return pred
        end
    end

    table.ifind = table.twoarg('any', function(array, pred, reverse)
        pred = predicate(pred)

        if not reverse then
            for i = 1, #array do
                local e = array[i]
                local m = pred(e, i)
                if m then
                    return e, i, m
                end
            end
        else
            for i = #array, 1, -1 do
                local e = array[i]
                local m = pred(e, i)
                if m then
                    return e, i, m
                end
            end
        end

        return nil, nil, nil
    end, 'ifind')

    table.find = table.twoarg('any', function(tbl, pred)
        pred = predicate(pred)

        for k, v in pairs(tbl) do
            local m = pred(v, k)
        end

        return nil, nil, nil
    end, 'find')

    local function search(tbl, pred, keys)
        local map = pred(tbl)
        if map then
            return tbl, keys, map
        end
        if type(tbl) == 'table' then
            local nk = #keys + 1
            for k, v in pairs(tbl) do
                keys[nk] = k
                local t, _, m = search(v, pred, keys)
                if t then return t, keys, m end
            end
            keys[nk] = nil
        else
            return nil, nil, nil
        end
    end

    table.search = table.twoarg('any', function(tbl, pred)
        pred = predicate(pred)
        return search(tbl, pred, {})
    end, 'search')

    table.reverse_lookup = table.twoarg('any', function(tbl, pred)
        local pred = predicate(pred)
        for k, v in pairs(tbl) do
            local res = pred(v)
            if res then return k, res end
        end
        return nil, nil
    end, 'reverse_lookup')

    table.remove_matching = table.twoarg('any', function(array, pred, all)
        local pred = predicate(pred)
        if all then
            local res = {}
            for ix = #array, 1, -1 do
                if pred(array[ix]) then
                    table.insert(res, table.remove(array, ix))
                end
            end
            return res
        else
            local _, ix = table.ifind(array, pred)
            if ix then 
                return table.remove(array, ix)
            else
                return nil
            end
        end
    end, 'remove_matching')
end