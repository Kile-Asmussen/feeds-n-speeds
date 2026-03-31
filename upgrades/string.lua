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
    else

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
    else

    return self .. char:rep(length - #self)
end