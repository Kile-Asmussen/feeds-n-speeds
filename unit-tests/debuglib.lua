--! Unit tests for debuglib.lua

local debuglib = import('debuglib')

-- __render_path tests
fact('__render_path handles string keys', function()
    local buffer = debuglib.new_buffer('root')
    table.insert(buffer.path_list, 'child')
    local path = buffer:__render_path()
    assert_eq(path, 'root.child')
end)

fact('__render_path handles numeric keys', function()
    local buffer = debuglib.new_buffer('arr')
    table.insert(buffer.path_list, 1)
    local path = buffer:__render_path()
    assert_eq(path, 'arr[1]')
end)

fact('__render_path handles boolean keys', function()
    local buffer = debuglib.new_buffer('tbl')
    table.insert(buffer.path_list, true)
    local path = buffer:__render_path()
    assert_eq(path, 'tbl[true]')
end)

fact('__render_path handles boolean as first key', function()
    local buffer = debuglib.new_buffer()
    table.insert(buffer.path_list, true)
    table.insert(buffer.path_list, 'next')
    local path = buffer:__render_path()
    assert_ok(type(path) == 'string', 'path should be a string')
end)

fact('__render_path handles nil in path_list', function()
    local buffer = debuglib.new_buffer('base')
    table.insert(buffer.path_list, nil)
    table.insert(buffer.path_list, 'key')
    local path = buffer:__render_path()
    assert_is(path, 'string')
end)

-- pp tests
fact('pp handles simple table', function()
    local result = debuglib.pp({a = 1})
    assert_is(result, 'string')
    assert_ok(result:match('a'), 'should contain key a')
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
    assert_ok(result:match('true'), 'should contain true')
end)

fact('pp handles table with boolean key', function()
    local tbl = {}
    tbl[true] = 'yes'
    tbl[false] = 'no'
    local result = debuglib.pp(tbl)
    assert_is(result, 'string')
end)