
local debuglib = require 'debuglib'

local modules = { 'debuglib', 'prelude', 'string', 'table' }

local __tests = {}

--- Register a test expected to pass
function fact(description, test_func)
    assert(type(description) == 'string', 'test description must be a string')
    assert(type(test_func) == 'function', 'test must be a function')
    table.insert(__tests, {description=description, test_func=test_func, success=true})
end

--- Register a test expected to fail (error)
function fiction(description, test_func)
    assert(type(description) == 'string', 'test description must be a string')
    assert(type(test_func) == 'function', 'test must be a function')
    table.insert(__tests, {description=description, test_func=test_func, success=false})
end

function assert(a, msg)
    if not a then error(msg or "assertion failed", 2)
end

--- Assertion helpers (global)
function assert_eq(a, b, msg)
    if a ~= b then
        error((msg or 'values not equal')
            .. ': expected ' .. tostring(b)
            .. ', got ' .. tostring(a), 2)
    end
end

function assert_is(val, expected_type, msg)
    if type(val) ~= expected_type then
        error((msg or 'not the right type')
            .. ': expected ' .. tostring(expected_type)
            .. ', got ' .. type(val), 2)
    end
end

local allowed_namespaces = table.set{
    'debuglib'
}

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
local __getinfo = debug.getinfo

-- sandboxing
-- Critical: filesystem, OS, module loading, sandbox escape                               
_ENV.require = nil
_ENV.io = nil
_ENV.os = nil
_ENV.package = nil
_ENV.debug = nil
_ENV.loadfile = nil
_ENV.dofile = nil
_ENV.load = nil
_ENV.loadstring = nil
_ENV.getfenv = nil
_ENV.setfenv = nil
_ENV.newproxy = nil
_ENV.rawget = nil
_ENV.table.rawget = nil
_ENV.rawset = nil
_ENV.table.rawset = nil
_ENV.getmetatable = nil
_ENV.table.getmetatable = nil
_ENV.setmetatable = nil
_ENV.table.setmetatable = nil
_ENV.coroutine = nil
_ENV.string.dump = nil
_ENV.collectgarbage = nil

--- Load test modules

for _, mod in ipairs(modules) do
    __require('unit-tests.' .. mod)
end

--- Run all tests
local passed = 0
local failed = 0

for _, test in ipairs(__tests) do

    local success, err = pcall(test.test_func)
    
    local info = __getinfo(test.test_func)
    local loc = info and tostring(info.short_src) .. ':' .. tostring(info.linedefined)
    loc = loc and ' (' .. loc .. ')' or ''

    if success ~= test.success then
        failed = failed + 1
        __print(test.description .. loc)
        __print('unexpected ' .. (test.success and 'error ' or 'return ') .. tostring(err))
        __print()
    else
        passed = passed + 1
    end
end

__print('Ran ' .. failed + passed .. ' tests: ' .. passed .. ' passed, ' .. failed .. ' failed')

if failed > 0 then
    __exit(1)
end


