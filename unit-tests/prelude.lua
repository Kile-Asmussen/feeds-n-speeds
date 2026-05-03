--! Unit tests for prelude.lua (namespace system)

-- fns() tests
fact('fns() generates prefixed identifier', function()
    local id = fns('test-item')
    assert_eq(id, 'feeds-n-speeds-test-item')
end)

fact('fns() normalizes special characters to dashes', function()
    local id = fns('foo_bar.baz')
    assert_eq(id, 'feeds-n-speeds-foo-bar-baz')
end)

fact('fns() preserves alphanumeric', function()
    local id = fns('ABC123')
    assert_eq(id, 'feeds-n-speeds-ABC123')
end)

fact('fns() takes two arguments', function()
    local id = fns('entity-description', 'thingy')
    assert_eq(id, 'entity-description.feeds-n-speeds-thingy')
    assert(table.index_of(fns_names_by_category('entity-description'), 'feeds-n-speeds-thingy'))
end)

fiction('fns() errors on number', function()
    fns(123)
end)

fiction('fns() errors on nil', function()
    fns(nil)
end)

-- namespace() tests
fact('namespace() creates new namespace', function()
    local ns = namespace 'test.ns.module1'
    assert_is(ns, 'table')
    assert_eq(tostring(ns), 'test.ns.module1')
end)

fiction('namespace() errors on duplicate path', function()
    namespace 'test.ns.dup1'
    namespace 'test.ns.dup1'
end)

fact('namespace() allows setting properties', function()
    local ns = namespace 'test.ns.module2'
    ns.foo = 'bar'
    ns.enabled = true
    assert_eq(ns.foo, 'bar')
    assert_eq(ns.enabled, true)
end)

fact('namespace() has __seal method', function()
    local ns = namespace 'test.ns.module3'
    assert_is(ns.__seal, 'function')
end)
-- import() tests
fact('import() retrieves declared namespace', function()
    local ns = namespace 'test.ns.importable'
    ns.value = 42
    local imported = import('test.ns.importable')
    assert_eq(imported, ns)
    assert_eq(imported.value, 42)
end)

fiction('import() errors on undeclared namespace', function()
    import('nonexistent.module.xyz')
end)

-- isnamespace() tests
fact('isnamespace() returns false for regular table', function()
    assert_eq(isnamespace({}), false)
end)

fact('isnamespace() returns false for non-table', function()
    assert_eq(isnamespace('string'), false)
    assert_eq(isnamespace(123), false)
    assert_eq(isnamespace(nil), false)
end)

fact('isnamespace() returns true for unsealed namespace', function()
    local ns = namespace 'test.ns.unsealed'
    assert(isnamespace(ns))
end)

fact('isnamespace() returns true for sealed namespace', function()
    local ns = namespace 'test.ns.sealcheck'
    seal_namespace(ns)
    assert(isnamespace(ns))
end)

-- __seal() tests
fact('__seal() seals the namespace', function()
    local ns = namespace 'test.ns.toseal'
    ns.data = 'before'
    local sealed = seal_namespace(ns)
    assert_eq(sealed, ns)
end)

fiction('sealed namespace errors on write', function()
    local ns = namespace 'test.ns.sealed1'
    ns.data = 'value'
    seal_namespace(ns)
    ns.newkey = 'fail'
end)

fact('sealed namespace allows read', function()
    local ns = namespace 'test.ns.sealed2'
    ns.data = 'readable'
    seal_namespace(ns)
    assert_eq(ns.data, 'readable')
end)

fact('__seal removes itself', function()
    local ns = namespace 'test.ns.sealed3'
    seal_namespace(ns)
    assert_eq(ns.__seal, nil)
end)

-- namespace() call syntax tests
fact('namespace call syntax retrieves value', function()
    local ns = namespace 'test.ns.callable'
    ns.mykey = 'myvalue'
    assert_eq(ns('mykey'), 'myvalue')
end)

fact('namespace call syntax returns nil for missing key', function()
    local ns = namespace 'test.ns.callable2'
    assert_eq(ns('nonexistent'), nil)
end)