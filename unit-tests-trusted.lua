fact('string.sprint handles tables via tostring', function()
    local tbl = table.setmetatable({}, {__tostring = function() return 'mytable' end})
    assert_eq(string.sprint(tbl), 'mytable')
end)

fact('table.iscallable returns true for callable table', function()
    local tbl = table.setmetatable({}, {__call = function() end})
    assert_eq(table.iscallable(tbl), true)
end)