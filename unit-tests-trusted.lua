local setmetatable = setmetatable
local getmetatable = getmetatable

fact('string.sprint handles tables via tostring', function()
    local tbl = setmetatable({}, {__tostring = function() return 'mytable' end})
    assert_eq(string.sprint(tbl), 'mytable')
end)
