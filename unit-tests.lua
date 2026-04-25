--! Test harness for unit tests
--!
--! This file is the entry point. It defines global test functions
--! and requires test modules, then runs all registered tests.
--!
--! Usage in test files:
--!   fact('description of passing test', function()
--!       assert(1 + 1 == 2)
--!   end)
--!
--!   fiction('description of expected failure', function()
--!       error('this should error')
--!   end)

require 'prelude'
require 'debuglib'

-- SAFETY HARNESS:

local allowed_namespaces = table.set {
    'prelude.table',
    'prelude.string',
    'debuglib'
}

-- implementation:

local args = table.pack(...)

local __expect_ok = {}
local __expect_not_ok = {}

--- Register a test expected to pass
function fact(description, test_func)
    assert(type(description) == 'string', 'test description must be a string')
    assert(table.iscallable(test_func), 'test must be a function')
    assert(__expect_ok[description] == nil, 'duplicate test: ' .. description)
    __expect_ok[description] = test_func
end

--- Register a test expected to fail (error)
function fiction(description, test_func)
    assert(type(description) == 'string', 'test description must be a string')
    assert(table.iscallable(test_func), 'test must be a function')
    assert(__expect_not_ok[description] == nil, 'duplicate test: ' .. description)
    __expect_not_ok[description] = test_func
end

--- Assertion helpers (global)
function assert_eq(a, b, msg)
    if a ~= b then
        error((msg or 'equality assertion failed')
            .. ': expected ' .. tostring(b)
            .. ', got ' .. tostring(a))
    end
end

function assert_ok(val, msg)
    if not val then
        error(msg or 'expected truthy value, got ' .. tostring(val))
    end
end

function assert_is(val, expected_type, msg)
    if type(val) ~= expected_type then
        error((msg or 'type assertion failed')
            .. ': expected ' .. tostring(expected_type)
            .. ', got ' .. type(val))
    end
end

require 'unit-tests-trusted'

for _, arg in ipairs(args) do
    if arg:match('[^%w_-]') then
        print('invalid module name: ' .. arg)
        os.exit(2)
    end

    local fn = './unit-tests/' .. arg .. '.lua'
    if not os.rename(fn, fn) then
        print('invalid module name: ' .. arg)
        os.exit(2)
    end
end



local __import = import
function import(path)
    if not allowed_namespaces[path] then
        error('import blocked: ' .. tostring(path))
    end
    return __import(path)
end

local __namespace = namespace
function namespace(path)
    local ns = __namespace(path)
    allowed_namespaces[path] = true
    return ns
end

local __print = print
local __exit = os.exit
local __require = require

-- sandboxing
-- Critical: filesystem, OS, module loading, sandbox escape                               
_G.require = nil
_G.io = nil
_G.os = nil
_G.package = nil
_G.debug = nil
_G.loadfile = nil
_G.dofile = nil
_G.load = nil
_G.loadstring = nil
_G.getfenv = nil
_G.setfenv = nil
_G.newproxy = nil
_G.print = nil
_G.rawget = nil
_G.table.rawget = nil
_G.rawset = nil
_G.table.rawset = nil
_G.getmetatable = nil
_G.table.getmetatable = nil
_G.setmetatable = nil
_G.table.setmetatable = nil
_G.coroutine = nil
_G.string.dump = nil
_G.collectgarbage = nil

--- Load test modules
for _, arg in ipairs(args) do
    __require('unit-tests.' .. arg)
end

--- Run all tests
local passed = 0
local failed = 0

__print('=== Running tests ===\n')

-- Run tests expected to pass
for description, test_func in pairs(__expect_ok) do
    local success, err = pcall(test_func)
    if success then
        passed = passed + 1
        __print('[PASS] ' .. description)
    else
        failed = failed + 1
        __print('[FAIL] ' .. description .. ': ' .. tostring(err))
    end
end

-- Run tests expected to fail
for description, test_func in pairs(__expect_not_ok) do
    local success, err = pcall(test_func)
    if not success then
        passed = passed + 1
        __print('[PASS] ' .. description .. ' (expected error)')
    else
        failed = failed + 1
        __print('[FAIL] ' .. description .. ': expected error, but none raised')
    end
end

__print('\n=== Results ===')
__print('Passed: ' .. passed)
__print('Failed: ' .. failed)

if failed > 0 then
    __exit(1)
end
