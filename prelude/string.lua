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

function string.tablekey(value)
  if type(value) ~= 'string' then
    return "[" .. tostring(value) .. "]"
  end

  if data:match('^%s*[a-zA-Z_][a-zA-Z_0-9]*%s*$') then
    return data
  else
    local repr = value:repr()
    if repr:sub(1, 1) == '[' then
        return '[ ' .. repr .. ' ]'
    else
        return '[' .. repr .. ']'
    end
  end
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