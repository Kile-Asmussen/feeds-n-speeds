return function(string, fns)

    local assert = fns.assert
    local type = fns.type

    function string.pattern(needle, index, plain)
        index = index or 1
        plain = plain and true or false
        assert(type(needle) == 'string', "string.pattern: argument #1 must be a string")
        assert(type(index) == 'number' and index >= 1 and index == fns.math.floor(index),
            "string.pattern: optional argument #2 must be a strictly positive integer, if given")
        local match = string.match
        return function(haystack) return match(haystack, needle, index, plain) end
    end

    function string.match_function(haystack, index, plain)
        index = index or 1
        plain = plain and true or false
        assert(type(haystack) == 'string', "argument #1 must be a string")
        assert(type(index) == 'number' and index >= 1 and index == fns.math.floor(index),
            "optional argument #2 must be a strictly positive integer if given")
        local match = string.match
        return function(needle) return match(haystack, needle, index, plain) end
    end

    function string.startswith(str, sample)
        assert(type(str) == 'string', "argument #1 must be a string")
        assert(type(sample) == 'string', "argument #2 must be a string")
        if sample == '' then return true end
        if #sample == #str then return sample == str end
        if #sample > #str then return false end
        return str:sub(1, #sample) == sample
    end

    function string.replace_prefix(str, sample, rep)
        rep = rep or ''
        assert(type(str) == 'string', "argument #1 must be a string")
        assert(type(sample) == 'string', "argument #2 must be a string")
        assert(type(rep) == 'string', "argument #3 must be a string")
        if str:startswith(sample) then
            if rep then
                return rep .. str:sub(#sample+1)
            else
                return str:sub(#sample+1)
            end
        else
            return str
        end
    end

    function string.endswith(str, sample)
        assert(type(str) == 'string', "argument #1 must be a string")
        assert(type(sample) == 'string', "argument #2 must be a string")
        if sample == '' then return true
        elseif #sample == #str then return sample == str
        elseif #sample > #str then return false
        else return str:sub(#str - #sample + 1) == sample
        end
    end

    function string.before(str, pat, include)
        assert(type(str) == 'string', "argument #1 must be a string")
        assert(type(pat) == 'string', "argument #2 must be a string")
        local ix, ix2 = str:find(pat, 1, true)
        if not ix then
            return str, false
        else
            if include then ix = ix2 + 1 end
            return str:sub(1, ix - 1), true
        end
    end

    function string.after(str, pat, include)
        assert(type(str) == 'string', "argument #1 must be a string")
        assert(type(pat) == 'string', "argument #2 must be a string")
        local ix, ix2 = str:find(pat, 1, true)
        if not ix then
            return nil
        else
            if include then ix2 = ix - 1 end
            return str:sub(ix2 + 1)
        end
    end

    local function stringlines_iter(state, lastline)
        local str, index = state[1], state[2]
        if str == nil then return nil end

        local next_index = str:find('\n', index + 1, true)

        if not next_index then
            state[1] = nil
            return str:sub(index + 1)
        else
            state[2] = next_index
            return str:sub(index + 1, next_index - 1)
        end
    end

    function string.lines(str)
        assert(type(str) == 'string', "argument #1 must be a string not " .. type(str))
        return stringlines_iter, {str, 0}, nil
    end

    function string.prepend(str)
        assert(type(str) == 'string', "argument #1 must be a string")
        return function(s) return str .. s end
    end

end