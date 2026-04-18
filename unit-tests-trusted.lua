local setmetatable = setmetatable
local getmetatable = getmetatable

fact('string.sprint handles tables via tostring', function()
    local tbl = setmetatable({}, {__tostring = function() return 'mytable' end})
    assert_eq(string.sprint(tbl), 'mytable')
end)

fact('table.iscallable returns true for callable table', function()
    local tbl = setmetatable({}, {__call = function() end})
    assert_eq(table.iscallable(tbl), true)
end)