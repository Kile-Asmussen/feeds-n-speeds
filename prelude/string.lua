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

function string.sprint(...)
    return table.concat(table.map(table.pack(...), tostring), '\t')
end

function string.chomp(str)
    if #str == 0 then
        return str
    end

    if str[#str] == '\n' then
        return str:sub(1, #str - 1)
    end

    return str
end