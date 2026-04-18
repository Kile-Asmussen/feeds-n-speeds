--! Unit tests for prelude/string.lua

-- string.lpad tests
fact('string.lpad pads shorter string', function()
    assert_eq(string.lpad('hi', 5), '   hi')
end)

fact('string.lpad with custom char', function()
    assert_eq(string.lpad('42', 5, '0'), '00042')
end)

fact('string.lpad returns string unchanged if already long enough', function()
    assert_eq(string.lpad('hello', 3), 'hello')
    assert_eq(string.lpad('hello', 5), 'hello')
end)

fiction('string.lpad errors on non-string pad char', function()
    string.lpad('hi', 5, 123)
end)

fiction('string.lpad errors on multi-char pad', function()
    string.lpad('hi', 5, 'ab')
end)

fact('string.lpad method syntax', function()
    assert_eq(('x'):lpad(4, '-'), '---x')
end)

-- string.rpad tests
fact('string.rpad pads shorter string', function()
    assert_eq(string.rpad('hi', 5), 'hi   ')
end)

fact('string.rpad with custom char', function()
    assert_eq(string.rpad('1', 4, '0'), '1000')
end)

fact('string.rpad returns string unchanged if already long enough', function()
    assert_eq(string.rpad('hello', 3), 'hello')
    assert_eq(string.rpad('hello', 5), 'hello')
end)

fiction('string.rpad errors on non-string pad char', function()
    string.rpad('hi', 5, 123)
end)

fiction('string.rpad errors on multi-char pad', function()
    string.rpad('hi', 5, 'ab')
end)

fact('string.rpad method syntax', function()
    assert_eq(('x'):rpad(4, '-'), 'x---')
end)

-- string.predicate tests
fact('string.predicate creates matcher', function()
    local pred = string.predicate('foo')
    assert_eq(pred('foobar'), 'foo')
    assert_eq(pred('bazqux'), nil)
end)

fact('string.predicate with custom function', function()
    local pred = string.predicate('hello', function(haystack, needle)
        return haystack == needle
    end)
    assert_eq(pred('hello'), true)
    assert_eq(pred('world'), false)
end)

fact('string.predicate with pattern', function()
    local pred = string.predicate('^%d+$')
    assert_eq(type(pred('12345')), 'string')
    assert_eq(pred('abc'), nil)
end)

fiction('string.predicate errors on non-callable', function()
    string.predicate('test', 'not a function')
end)

-- string.sprint tests
fact('string.sprint single value', function()
    assert_eq(string.sprint('hello'), 'hello')
end)

fact('string.sprint multiple values', function()
    assert_eq(string.sprint('a', 'b', 'c'), 'a\tb\tc')
end)

fact('string.sprint converts to string', function()
    assert_eq(string.sprint(1, 2, 3), '1\t2\t3')
end)


fact('string.sprint empty', function()
    assert_eq(string.sprint(), '')
end)

-- string.chomp tests
fact('string.chomp removes trailing newline', function()
    assert_eq(string.chomp('hello\n'), 'hello')
end)

fact('string.chomp leaves string without newline unchanged', function()
    assert_eq(string.chomp('hello'), 'hello')
end)

fact('string.chomp handles empty string', function()
    assert_eq(string.chomp(''), '')
end)

fact('string.chomp only removes last newline', function()
    assert_eq(string.chomp('a\nb\n'), 'a\nb')
end)

fact('string.chomp method syntax', function()
    assert_eq(('world\n'):chomp(), 'world')
end)
