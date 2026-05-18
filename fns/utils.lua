local utils = require('namespace')('utils')

function utils.tableindex(value, first)
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

function utils.tablepath(base, path)
    local res = { tostring(base) }
    if path ~= nil then
        assert(type(path) == 'table', "expected argument #2 to be a table")
        for _, v in ipairs(path) do
            table.insert(res, string.tableindex(v))
        end
    end
    return table.concat(res)
end

return utils:seal()