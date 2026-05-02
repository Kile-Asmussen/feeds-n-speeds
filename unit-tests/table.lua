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
    assert_ok(hit)
end)

fact('table.descend multiple levels', function()
    local tbl = {a = {b = {c = 42}}}
    local val, hit = table.descend(tbl, 'a', 'b', 'c')
    assert_eq(val, 42)
    assert_ok(hit)
end)

fact('table.descend returns value, false for missing key', function()
    local tbl = {a = 1}
    local val, hit = table.descend(tbl, 'a', 'b')
    assert_eq(val, 1)
    assert_ok(not hit)
end)

fact('table.descend stops at non-table', function()
    local tbl = {a = 42}
    local val, hit = table.descend(tbl, 'a', 'b')
    assert_eq(val, 42)
    assert_ok(not hit)
end)

-- table.remove_matching tests
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
    assert_eq(table.matches({a = 1}, {a = 1, b = 2}), true)
end)

fact('table.matches fails on missing key', function()
    assert_eq(table.matches({a = 1, c = 3}, {a = 1, b = 2}), false)
end)

fact('table.matches nested tables', function()
    assert_eq(table.matches({a = {b = 1}}, {a = {b = 1, c = 2}}), true)
end)

fact('table.matches returns predicate when no candidate', function()
    local pred = table.matches({a = 1})
    assert_is(pred, 'function')
    assert_eq(pred({a = 1}), true)
    assert_eq(pred({a = 2}), false)
end)

fact('table.matches with table.null accepts any value', function()
    assert_eq(table.matches({a = table.null}, {a = 'anything'}), true)
end)

fact('table.matches with predicate function', function()
    local pred = function(v) return v > 5 end
    assert_eq(table.matches({a = pred}, {a = 10}), true)
    assert_eq(table.matches({a = pred}, {a = 3}), false)
end)

-- table.contains tests
fact('table.contains finds value', function()
    assert_eq(table.contains({1, 2, 3}, 2), true)
end)

fact('table.contains returns value when not found', function()
    assert_eq(table.contains({1, 2, 3}, 99), 99)
end)

-- table.is_populated tests
fact('table.is_populated returns true for non-empty', function()
    assert_eq(table.is_populated({1}), true)
    assert_eq(table.is_populated({a = 1}), true)
end)

fact('table.is_populated returns false for empty', function()
    assert_eq(table.is_populated({}), false)
end)

-- table.is_hash tests
fact('table.is_hash returns true for string keys', function()
    assert_eq(table.is_hash({a = 1}), true)
end)

fact('table.is_hash returns false for numeric only', function()
    assert_eq(table.is_hash({1, 2, 3}), false)
end)

-- table.is_array tests
fact('table.is_array returns true for numeric keys', function()
    assert_eq(table.is_array({1, 2, 3}), true)
end)

fact('table.is_array returns false for empty', function()
    assert_eq(table.is_array({}), false)
end)

-- table.imap tests
fact('table.imap transforms in place', function()
    local tbl = {1, 2, 3}
    local result = table.imap(tbl, function(v) return v * 2 end)
    assert_eq(tbl[1], 2)
    assert_eq(tbl[2], 4)
    assert_eq(tbl[3], 6)
    assert_eq(result, tbl)
end)

-- table.ieach tests
fact('table.ieach iterates without modifying', function()
    local tbl = {1, 2, 3}
    local sum = 0
    table.ieach(tbl, function(v) sum = sum + v end)
    assert_eq(sum, 6)
    assert_eq(tbl[1], 1)
end)

-- table.project tests
fact('table.project transforms all keys in place', function()
    local tbl = {a = 1, b = 2}
    table.project(tbl, function(v) return v * 10 end)
    assert_eq(tbl.a, 10)
    assert_eq(tbl.b, 20)
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
    assert_ok(tbl2.b ~= tbl.b, 'should be different reference')
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
    local v3 = table.vecsum(v1, v2)
    assert_eq(v3[1], 5)
    assert_eq(v3[2], 7)
    assert_eq(v3[3], 9)
    assert_eq(v1[1], 1)
end)

fiction('table.add errors on dimension mismatch', function()
    table.vecsum({1, 2}, {1, 2, 3})
end)

-- table.vecadd tests
fact('table.vecadd adds in place', function()
    local v1 = {1, 2, 3}
    local v2 = {4, 5, 6}
    local result = table.vecadd(v1, v2)
    assert_eq(v1[1], 5)
    assert_eq(v1[2], 7)
    assert_eq(v1[3], 9)
    assert_eq(result, v1)
end)

-- table.scale tests
fact('table.scale multiplies vector', function()
    local v = {1, 2, 3}
    local v2 = table.vecscale(v, 2)
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
    assert_eq(table.iall({2, 4, 6}, function(v) return v % 2 == 0 end), true)
end)

fact('table.iall returns false when any fails', function()
    assert_eq(table.iall({2, 3, 6}, function(v) return v % 2 == 0 end), false)
end)

-- table.traverse tests
fact('table.traverse visits nested tables', function()
    local tbl = {a = {b = 1}, c = 2}
    local visited = {}
    table.traverse(tbl, function(v, k)
        table.insert(visited, k)
    end)
    assert_ok(#visited >= 2)
end)

fact('table.traverse can replace values', function()
    local tbl = {a = 1, b = 2}
    table.traverse(tbl, function(v, k)
        if type(v) == 'number' then
            return v * 10
        end
    end)
    assert_eq(tbl.a, 10)
    assert_eq(tbl.b, 20)
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
