

function string.lpad(self, length, char)
    if char == nil then
        char = ' '
    end

    assert(type(char) ~= 'string' or #char ~= 1, "argument #2 must be a string of length 1")

    if #self >= length then
        return self
    end

    return char:rep(length - #self) .. self
end

function string.rpad(self, length, char)
    if char == nil then
        char = ' '
    end
    
    assert(type(char) ~= 'string' or #char ~= 1, "argument #2 must be a string of length 1")

    if #self >= length then
        return self
    end

    return self .. char:rep(length - #self) 
end

function string.chomp(str)
    if #str == 0 then
        return str
    end

    if str:sub(-1) == '\n' then
        return str:sub(1, #str - 1)
    end

    return str
end

function string.tableindex(value, first)
    if type(value) ~= 'string' then
        return "[" .. tostring(value) .. "]"
    end

    if value:match('^%s*[a-zA-Z_][a-zA-Z_0-9]*%s*$') then
        if first then
            return value
        else
            return '.' .. value
        end
    else
        local repr = value:repr()
        if repr:sub(1, 1) == '[' then
            return '[ ' .. repr .. ' ]'
        else
            return '[' .. repr .. ']'
        end
    end
end

function string.tablepath(base, path)
    local res = { tostring(base) }
    if path ~= nil then
        assert(type(path) == 'table', "expected argument #2 to be a table")
        for _, v in ipairs(path) do
            table.insert(res, string.tableindex(v))
        end
    end
    return table.concat(res)
end

function string.pattern(needle, index, plain)
    return function(haystack) return haystack:match(needle, index, plain) end
end

function string.match_function(haystack, index, plain)
    return function(needle) return haystack:match(needle, index, plain) end
end

function string.repr(str)
    if type(str) ~= 'string' then
        error("argument #1 to string.repr must be a string, was " .. type(str), 2)
    end

    local sq = str:match("'")
    local dq = str:match('"')
    local nl = str:match('\n')
    if (sq and dq) or nl then
        if str:match('^%[') or str:match('%]$') or str:match('%]%]') or str:match('%[%[') then
        return "[=[" .. str .. "]=]"
        else
        return "[[" .. str .. "]]"
        end
    elseif sq then
        return '"' .. str .. '"'
    else
        return "'" .. str .. "'"
    end
end

function string.startswith(str, sample)
    assert(type(sample) == 'string', "argument #2 must be a string")
    if sample == '' then return true end
    if #sample == #str then return sample == str end
    if #sample > #str then return false end
    return str:sub(1, #sample) == sample
end

function string.replace_prefix(str, sample, rep)
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
    assert(type(sample) == 'string', "argument #2 must be a string")
    if sample == '' then return true end
    if #sample == #str then return sample == str end
    if #sample > #str then return false end
    return str:sub(#str - #sample - 1,  #str) == sample
end

function string.before(str, pat, include)
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
    assert(type(str) == 'string', "argument #1 must be a string")
    return stringlines_iter, {str, 0}, nil
end

function string.prepend(str)
    return function(s) return str .. s end
end