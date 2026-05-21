local table = _ENV.table

function table.match(candidate, reference)

    if type(reference) == 'function' then
        return reference(candidate)
    elseif type(reference) ~= 'table' then
        return reference == candidate
    end


    if type(candidate) ~= "table" then return nil end

    for key, ref in pairs(reference) do

        local can = candidate[key]

        if can == nil then return nil end

        if type(ref) == 'function' and ref(can) then return true end

        if type(ref) ~= type(can) then return nil end

        if type(can) == "table" then
            if not table.match(ref, can) then
                return nil
            end
        elseif ref ~= can then
            return nil            
        end
    end

    return true
end

function table.pattern(ref)
    return function(can)
        return table.match(can, ref)
    end
end

local function __index_of(array, fn)
    local index = nil

    for i, e in ipairs(array) do
        if fn(e) then
            index = i
            break
        end
    end

    return index
end

function table.index_matching(array, thing)
    if type(thing) ~= 'function' then
        thing = table.pattern(thing)
    end

    assert(type(array) == 'table', "argument #1 must be a table")

    return __index_of(array, thing)
end

function table.remove_matching(array, thing, all)
    if type(thing) ~= 'function' then
        thing = table.pattern(thing)
    end
    assert(type(array) == 'table', "argument #1 must be a table")

    if all then
        local res = {}
        local ix = __index_of(array, thing)
        while ix do
            table.insert(res, table.remove(array, ix))
            ix = __index_of(array, thing)
        end
        return res
    else
        local ix = __index_of(array, thing)
        if ix then 
            return table.remove(array, ix)
        else
            return nil
        end
    end
end

function table.find_matching(array, thing)
    if type(thing) ~= 'function' then
        thing = table.pattern(thing)
    end
    assert(type(array) == 'table', "argument #1 must be a table, not " .. tostring(array))

    local ix = __index_of(array, thing)
    if ix then 
        return array[ix]
    else
        return nil
    end
end