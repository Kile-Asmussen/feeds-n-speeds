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
local debuglib = require 'debuglib'

-- implementation:

local args = table.pack(...)
args.n = nil

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

--- Assertion helpers (global)
function assert_eq(a, b, msg)
    if a ~= b then
        error((msg or 'values not equal')
            .. ': expected ' .. tostring(b)
            .. ', got ' .. tostring(a))
    end
end

function assert_is(val, expected_type, msg)
    if type(val) ~= expected_type then
        error((msg or 'not the right type')
            .. ': expected ' .. tostring(expected_type)
            .. ', got ' .. type(val))
    end
end

if #args == 1 and args[1] == 'all' then
    local find = io.popen("find ./unit-tests/ -type f -name '*.lua'")
    table.remove(args)
    for path in find:lines() do
        local name = path:match('/[%w]+%.lua$')
        if name then
            name = name:sub(2, #name - 4)
            table.insert(args, name)
        end
    end
end

if table.remove_matching(args, 'trusted') then
    require 'unit-tests-trusted'
end

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
