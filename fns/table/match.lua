
local table = _ENV.table
local assert = _ENV.assert

local function __match(candidate, reference)
    if candidate == nil and reference == nil then return true end

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

    return candidate
end

table.twoarg('match', __match, 'any?', 'any?')

local function __index_of(array, fn, reverse)
    if not reverse then
        for i = 1, #array do
            local e = array[i]
            local m = fn(e)
            if m then
                return i, e, m
            end
        end
    else
        for i = #array, 1, -1 do
            local e = array[i]
            local m = fn(e)
            if m then
                return i, e, m
            end
        end
    end

    return nil, nil, nil
end

function table.find(array, thing, last)
    if type(thing) ~= 'function' then
        thing = table.match(thing)
    end

    assert(type(array) == 'table', "argument #1 must be a table")

    return __index_of(array, thing, last and true or false)
end

function table.remove_matching(array, thing, all)
    if type(thing) ~= 'function' then
        thing = table.match(thing)
    end
    assert(type(array) == 'table', "argument #1 must be a table")

    if all then
        local res = {}
        for ix = #array, 1, -1 do
            if thing(array[ix]) then
                table.insert(res, table.remove(array, ix))
            end
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
        thing = table.match(thing)
    end
    assert(type(array) == 'table', "argument #1 must be a table, not " .. tostring(array))

    local _, e = __index_of(array, thing)
    return e
end