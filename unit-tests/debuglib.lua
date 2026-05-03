--! Unit tests for debuglib.lua

local debuglib = import('debuglib')

-- pp tests
fact('pp handles simple table', function()
    local result = debuglib.pp({a = 1})
    assert_is(result, 'string')
    assert(result:match('a'), 'should contain key a')
end)

fact('pp handles nested table', function()
    local result = debuglib.pp({outer = {inner = 'value'}})
    assert_is(result, 'string')
end)

fact('pp handles array', function()
    local result = debuglib.pp({1, 2, 3})
    assert_is(result, 'string')
end)

fact('pp handles empty table', function()
    local result = debuglib.pp({})
    assert_eq(result, '{}')
end)

fact('pp handles boolean values', function()
    local result = debuglib.pp({flag = true})
    assert(result:match('true'), 'should contain true')
end)

fact('pp handles table with boolean key', function()
    local tbl = {}
    tbl[true] = 'yes'
    tbl[false] = 'no'
    local result = debuglib.pp(tbl)
    assert_is(result, 'string')
end)