--! Unit tests for debuglib.lua

local debuglib = import('debuglib')

-- __render_path tests
fact('__render_path handles string keys', function()
    local buffer = debuglib.__new_buffer('root')
    table.insert(buffer.path_list, 'child')
    local path = buffer:__render_path()
    assert_eq(path, 'root.child')
end)

fact('__render_path handles numeric keys', function()
    local buffer = debuglib.__new_buffer('arr')
    table.insert(buffer.path_list, 1)
    local path = buffer:__render_path()
    assert_eq(path, 'arr[1]')
end)

fact('__render_path handles boolean keys', function()
    local buffer = debuglib.__new_buffer('tbl')
    table.insert(buffer.path_list, true)
    local path = buffer:__render_path()
    assert_eq(path, 'tbl[true]')
end)

fact('__render_path handles boolean as first key', function()
    local buffer = debuglib.__new_buffer()
    table.insert(buffer.path_list, true)
    table.insert(buffer.path_list, 'next')
    local path = buffer:__render_path()
    assert_ok(type(path) == 'string', 'path should be a string')
end)

fact('__render_path handles nil in path_list', function()
    local buffer = debuglib.__new_buffer('base')
    table.insert(buffer.path_list, nil)
    table.insert(buffer.path_list, 'key')
    local path = buffer:__render_path()
    assert_is(path, 'string')
end)

-- sprint tests
fact('sprint handles simple table', function()
    local result = debuglib.sprint({a = 1})
    assert_is(result, 'string')
    assert_ok(result:match('a'), 'should contain key a')
end)

fact('sprint handles nested table', function()
    local result = debuglib.sprint({outer = {inner = 'value'}})
    assert_is(result, 'string')
end)

fact('sprint handles array', function()
    local result = debuglib.sprint({1, 2, 3})
    assert_is(result, 'string')
end)

fact('sprint handles empty table', function()
    local result = debuglib.sprint({})
    assert_eq(result, '{}')
end)

fact('sprint handles boolean values', function()
    local result = debuglib.sprint({flag = true})
    assert_ok(result:match('true'), 'should contain true')
end)

fact('sprint handles table with boolean key', function()
    local tbl = {}
    tbl[true] = 'yes'
    tbl[false] = 'no'
    local result = debuglib.sprint(tbl)
    assert_is(result, 'string')
end)

-- __render_key tests
fact('__render_key handles identifier-like strings', function()
    local key = debuglib.__render_key('foo_bar')
    assert_eq(key, 'foo_bar')
end)

fact('__render_key handles numeric keys', function()
    local key = debuglib.__render_key(42)
    assert_eq(key, "['42']")
end)

fact('__render_key handles strings with special chars', function()
    local key = debuglib.__render_key('foo-bar')
    assert_ok(key:match('%['), 'should be bracketed')
end)

-- __render_string tests
fact('__render_string uses single quotes by default', function()
    local str = debuglib.__render_string('hello')
    assert_eq(str, "'hello'")
end)

fact('__render_string uses double quotes when string has single quote', function()
    local str = debuglib.__render_string("it's")
    assert_eq(str, '"it\'s"')
end)

fact('__render_string uses long brackets for mixed quotes', function()
    local str = debuglib.__render_string([[it's a "test"]])
    assert_ok(str:match('%[%[') or str:match('%[=%['), 'should use long brackets')
end)

-- descent tests
fact('descent builds path from keys', function()
    local path = debuglib.descent('a', 'b', 'c')
    assert_eq(path, '.a.b.c')
end)

fact('descent handles numeric keys', function()
    local path = debuglib.descent('arr', 1)
    assert_ok(path:match("%['1'%]"), 'should bracket numeric key')
end)
