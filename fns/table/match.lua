
return function(table, fns)
    local assert = fns.assert
    local type = fns.type
    local pairs = table.pairs

    local match
    function table.match(candidate, reference)

        if type(candidate) ~= "table" then return nil end

        for key, ref in pairs(reference) do

            local can = candidate[key]

            if type(ref) == 'function' and ref(can) then return candidate end

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
    match = table.match

    table.declare_twoarg('match', 'any?', 'table')

    function table.find(array, pred, reverse)
        if not reverse then
            for i = 1, #array do
                local e = array[i]
                local m = pred(e)
                if m then
                    return e, i, m
                end
            end
        else
            for i = #array, 1, -1 do
                local e = array[i]
                local m = pred(e)
                if m then
                    return e, i, m
                end
            end
        end

        return nil, nil, nil
    end
    local find = table.find
    table.declare_twoarg('find', 'function')

    function table.reverse_lookup(tbl, value)
        for k, v in pairs(tbl) do
            if v == value then return k end
        end
        return nil
    end
    table.declare_twoarg('reverse_lookup', 'any')

    function table.remove_matching(array, pred, all)
        if all then
            local res = {}
            for ix = #array, 1, -1 do
                if pred(array[ix]) then
                    table.insert(res, table.remove(array, ix))
                end
            end
            return res
        else
            local _, ix = find(array, pred)
            if ix then 
                return table.remove(array, ix)
            else
                return nil
            end
        end
    end
    table.declare_twoarg('remove_matching', 'function')
end