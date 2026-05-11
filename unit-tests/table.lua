--! Unit tests for prelude/table.lua

-- table.null tests
fact('table.null tostring', function()
    assert_eq(tostring(table.null), 'table.null')
end)

fiction('table.null errors on newindex', function()
    table.null.foo = 1
end)


-- table.descend tests
fact('table.descend single level', function()
    local tbl = {a = 1}
    local val, hit = table.descend(tbl, 'a')
    assert_eq(val, 1)
    assert(hit)
end)

fact('table.descend multiple levels', function()
    local tbl = {a = {b = {c = 42}}}
    local val, hit = table.descend(tbl, 'a', 'b', 'c')
    assert_eq(val, 42)
    assert(hit)
end)

fact('table.descend returns value, false for missing key', function()
    local tbl = {a = 1}
    local val, hit = table.descend(tbl, 'a', 'b')
    assert_eq(val, 1)
    assert(not hit)
end)

fact('table.descend stops at non-table', function()
    local tbl = {a = 42}
    local val, hit = table.descend(tbl, 'a', 'b')
    assert_eq(val, 42)
    assert(not hit)
end)

------------

fact('table.index_of works with functions', function()
    local tbl = {1, 2, 3, 4, 5}
    local val = table.index_of(tbl, function(e) return e == 3 end)
    assert_eq(val, 3)
end)

fact('table.index_of works with numbers', function()
    local tbl = {1, 2, 3, 4, 5}
    local val = table.index_of(tbl, 3)
    assert_eq(val, 3)
end)


fact('table.index_of works with strings', function()
    local tbl = {1, "2", "3", "4", 5}
    local val = table.index_of(tbl, "3")
    assert_eq(val, 3)
end)


fact('table.index_of works with associative arrays', function()
    local tbl = {1, 2, {n=3}, {n=4}, {n=5}}
    local val = table.index_of(tbl, {n=3})
    assert_eq(val, 3)
end)

fact('table.index_of works with arrays', function()
    local tbl = {1, 2, {3}, {4}, 5}
    local val = table.index_of(tbl, {3})
    assert_eq(val, 3)
end)

-----------------

fact('table.remove_matching finds and removes matching element', function()
    local tbl = {1, 2, 3, 4, 5}
    local val = table.remove_matching(tbl, function(e) return e == 3 end)
    assert_eq(val, 3)
    assert_eq(#tbl, 4)
    assert_eq(tbl[3], 4)
end)

fact('table.remove_matching returns nil when not found', function()
    local tbl = {1, 2, 3}
    local val = table.remove_matching(tbl, function(e) return e == 99 end)
    assert_eq(val, nil)
    assert_eq(#tbl, 3)
end)

-- table.find_matching tests
fact('table.find_matching finds matching element', function()
    local tbl = {{name = 'a'}, {name = 'b'}, {name = 'c'}}
    local found = table.find_matching(tbl, function(e) return e.name == 'b' end)
    assert_eq(found.name, 'b')
end)

-- table.find_matching tests
fact('table.find_matching finds table element', function()
    local tbl = {{name = 'a', thing = 1}, {name = 'b', thing = 2}, {name = 'c', thing = 3}}
    local found = table.find_matching(tbl, { name = 'b' })
    assert_eq(found.thing, 2)
end)

-- table.remove_matching tests
fact('table.remove_matching finds and removes element', function()
    local tbl = {1, 2, 3, 4, 5}
    local val = table.remove_matching(tbl, 3)
    assert_eq(val, 3)
    assert_eq(#tbl, 4)
    assert_eq(tbl[3], 4)
end)

fact('table.find_matching returns nil when not found', function()
    local tbl = {1, 2, 3}
    local found = table.find_matching(tbl, function(e) return e == 99 end)
    assert_eq(found, nil)
end)

-- table.matches tests
fact('table.matches simple equality', function()
    assert(table.match({a = 1}, {a = 1, b = 2}))
end)

fact('table.matches fails on missing key', function()
    assert(not table.match({a = 1, c = 3}, {a = 1, b = 2}))
end)

fact('table.matches nested tables', function()
    assert(table.match({a = {b = 1}}, {a = {b = 1, c = 2}}))
end)

fact('table.matches returns predicate when no candidate', function()
    local pred = table.match({a = 1})
    assert_is(pred, 'function')
    assert(pred{a = 1})
    assert(not pred{a = 2})
end)

fact('table.matches with table.null accepts any value', function()
    assert_eq(table.match({a = table.null}, {a = 'anything'}), true)
end)

fact('table.matches with predicate function', function()
    local pred = function(v) return v > 5 end
    assert_eq(table.match({a = pred}, {a = 10}), true)
    assert_eq(table.match({a = pred}, {a = 3}), false)
end)

-- table.is_populated tests
fact('table.is_empty returns false for non-empty', function()
    assert(not table.is_empty({1}))
    assert(not table.is_empty({a = 1}))
end)

fact('table.is_populated returns true for empty', function()
    assert(table.is_empty({}))
end)

-- table.is_assoc, has_assoc tests
fact('table.is_assoc and has_assoc properties', function()
    assert(    table.is_assoc({a = 1}))
    assert(    table.has_assoc({a = 1}))

    assert(not table.is_assoc({1, 2, 3}))
    assert(not table.has_assoc({1, 2, 3}))

    assert(not table.is_assoc({3, n = 1}))
    assert(    table.has_assoc({3, n = 1}))

    assert(    table.is_assoc({}))
    assert(not table.has_assoc({}))

    assert(not table.is_assoc({[100] = 'a'}))
    assert(not table.has_assoc({[100] = 'a'}))
end)

-- table.is_array tests
fact('table.is_array and has_array properties', function()
    assert(not table.is_array({a = 1}))
    assert(not table.has_array({a = 1}))

    assert(    table.is_array({1, 2, 3}))
    assert(    table.has_array({1, 2, 3}))
    
    assert(not table.is_array({3, n = 1}))
    assert(    table.has_array({3, n = 1}))

    assert(    table.is_array({}))
    assert(not table.has_array({}))

    assert(    table.is_array({[100] = 'a'}))
    assert(    table.has_array({[100] = 'a'}))
end)


-- table.map tests
fact('table.collect creates new table', function()
    local tbl = {a = 1, b = 2}
    local tbl2 = table.collect(tbl, function(v) return v * 10 end)
    assert_eq(tbl.a, 1)
    assert_eq(tbl2.a, 10)
    assert_eq(tbl2.b, 20)
end)

-- table.clone tests
fact('table.clone deep copies', function()
    local tbl = {a = 1, b = {c = 2}}
    local tbl2 = table.clone(tbl)
    assert_eq(tbl2.a, 1)
    assert_eq(tbl2.b.c, 2)
    assert(tbl2.b ~= tbl.b, 'should be different reference')
end)

-- table.sorted_keys tests
fact('table.sorted_keys returns sorted array', function()
    local tbl = {c = 1, a = 2, b = 3}
    local keys = table.sorted_keys(tbl)
    assert_eq(keys[1], 'a')
    assert_eq(keys[2], 'b')
    assert_eq(keys[3], 'c')
end)

-- table.set tests
fact('table.set converts array to set', function()
    local s = table.set({'a', 'b', 'c'})
    assert_eq(s.a, true)
    assert_eq(s.b, true)
    assert_eq(s.c, true)
    assert_eq(s.d, nil)
end)

-- table.append tests
fact('table.append concatenates arrays', function()
    local t1 = {1, 2}
    local t2 = {3, 4}
    table.append(t1, t2)
    assert_eq(#t1, 4)
    assert_eq(t1[3], 3)
    assert_eq(t1[4], 4)
end)

-- table.add tests
fact('table.add sums vectors', function()
    local v1 = {1, 2, 3}
    local v2 = {4, 5, 6}
    local v3 = table.vecsum(v1, v2, {})
    assert_eq(v3[1], 5)
    assert_eq(v3[2], 7)
    assert_eq(v3[3], 9)
    assert_eq(v1[1], 1)
end)

fiction('table.add errors on dimension mismatch', function()
    table.vecsum({1, 2}, {1, 2, 3})
end)

-- table.vecadd tests
fact('table.vecsum adds in place', function()
    local v1 = {1, 2, 3}
    local v2 = {4, 5, 6}
    local result = table.vecsum(v1, v2)
    assert_eq(v1[1], 5)
    assert_eq(v1[2], 7)
    assert_eq(v1[3], 9)
    assert_eq(result, v1)
end)

-- table.scale tests
fact('table.vecmul multiplies vector', function()
    local v = {1, 2, 3}
    local v2 = table.vecmul(v, 2, {})
    assert_eq(v2[1], 2)
    assert_eq(v2[2], 4)
    assert_eq(v2[3], 6)
    assert_eq(v[1], 1)
end)

-- table.vecmul tests
fact('table.vecmul scales in place', function()
    local v = {1, 2, 3}
    table.vecmul(v, 3)
    assert_eq(v[1], 3)
    assert_eq(v[2], 6)
    assert_eq(v[3], 9)
end)

-- table.sum tests
fact('table.sum adds numbers', function()
    assert_eq(table.sum({1, 2, 3, 4}), 10)
end)

fact('table.sum with initial value', function()
    assert_eq(table.sum({1, 2, 3}, 10), 16)
end)

fact('table.sum empty array', function()
    assert_eq(table.sum({}), 0)
end)

-- table.iall tests
fact('table.iall returns true when all match', function()
    assert_eq(table.all({2, 4, 6}, function(v) return v % 2 == 0 end), true)
end)

fact('table.iall returns false when any fails', function()
    assert_eq(table.all({2, 3, 6}, function(v) return v % 2 == 0 end), false)
end)

-- table.isvec tests
fact('table.isvec returns true for 2-number table', function()
    assert_eq(table.isvec({1, 2}), true)
    assert_eq(table.isvec({0.5, -3.14}), true)
end)

fact('table.isvec returns false for wrong length', function()
    assert_eq(table.isvec({1}), false)
    assert_eq(table.isvec({1, 2, 3}), false)
end)

fact('table.isvec returns false for non-numbers', function()
    assert_eq(table.isvec({'a', 'b'}), false)
    assert_eq(table.isvec({1, 'b'}), false)
end)

fact('table.isvec returns false for non-table', function()
    assert_eq(table.isvec(42), false)
    assert_eq(table.isvec('hello'), false)
end)
