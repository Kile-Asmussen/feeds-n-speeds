function string.lpad(self, length, char)
    if char == nil then
        char = ' '
    end
    if type(char) ~= 'string' then
        error("cannot pad with non-string")
    end
    if #char ~= 1 then
        error("cannot pad with string of length other than 1")
    end

    if #self >= length then
        return self
    end

    return char:rep(length - #self) .. self
end

function string.rpad(self, length, char)
    if char == nil then
        char = ' '
    end
    if type(char) ~= 'string' then
        error("cannot pad with non-string")
    end

    if #char ~= 1 then
        error("cannot pad with string of length other than 1")
    end

    if #self >= length then
        return self
    end

    return self .. char:rep(length - #self)
end

function string.predicate(needle, func)
    func = func or string.match
    assert(table.iscallable(func), "Predicate given isn't callable.")
    return function(haystack) return func(haystack, needle) end
end

function string.sprint(...)
    return table.concat(table.imap(table.pack(...), tostring), '\t')
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

function string.matcher(needle, index, plain)
    return function(haystack) return haystack:match(needle, index, plain) end
end

function string.matched_by(haystack, index, plain)
    return function(needle) return haystack:match(needle, index, plain) end
end

function string.matches(needle, haystack, index, plain)
    return haystack:match(needle, index, plain)
end

function string.repr(str)
    if type(str) ~= 'string' then
        error("argument #1 to string.repr must be a string, was " .. type(str))
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

function string.lines(str)
    return function()
        if str == '' then return nil end
        local ix = (str:find('\n') or #str)
        local line = str:sub(1, ix) 
        str = str:sub(ix+1)
        return line
    end
end