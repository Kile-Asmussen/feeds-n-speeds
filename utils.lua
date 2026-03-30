function table.remove_matching(array, predicate)

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

function table.find_matching(array, predicate)
    for _, e in ipairs(array) do
        if predicate(e) then
            return e
        end
    end
end

utils = {}

function utils.matches(reference, candidate)
    if type(reference) ~= "table" then
        error("Cannot match on non-table data of type " .. type(reference))
    end

    if candidate == nil then
        return function(candidate)
            if candidate == nil then return false end
            return utils.matches(reference, candidate)
        end
    end

    if type(candidate) ~= "table" then return false end

    for key, ref in pairs(reference) do

        test = candidate[key]

        if test == nil then return false end

        if type(ref) ~= type(test) then return false end

        if type(test) == "table" then
            if not utils.matches(ref, test) then
                return false
            end
        elseif ref ~= test then
            return false            
        end
    end

    return true
end