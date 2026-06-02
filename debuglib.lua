local fns = require 'fns'
local namespace = require 'namespace'
local debuglib = namespace 'debuglib'

local table = fns.table
local string = fns.string

debuglib.recursion_limit = 2
debuglib.serialize = false
debuglib.seen_tables = { [_ENV] = '_ENV' }

debuglib.io = _ENV.io and { open = _ENV.io.open } or {}

local table = fns.table
local string = fns.string
local utils = fns.utils

function debuglib.pp(data, root)
    local settings = {
        depth_limit = debuglib.recursion_limit or 2,
        func_names = debuglib.serialize,
        indent = '  ',
        separator = '\n',
        bare_keys = false,
        small = { size = 4, length = 50, indent = '', separator = ' ' },
        root = root,
    }

    if data == _ENV then
        data = table.dup(_ENV)
        settings.root = settings.root or '_ENV'
    else
        settings.root = settings.root or '_'
    end

    local buffer = debuglib.new_buffer(settings)
    buffer:print_any(data)
    return tostring(buffer)
end


function debuglib.p(data, root)
    local settings = {
        depth_limit = debuglib.recursion_limit or 2,
        indent = '',
        func_names = debuglib.serialize,
        separator = ' ',
        small = nil,
        root = root,
    }

    if data == _ENV then
        data = table.dup(_ENV)
        settings.root = settings.root or '_ENV'
    else
        settings.root = settings.root or '_'
    end

    local buffer = debuglib.new_buffer(settings)
    buffer:print_any(data)
    return tostring(buffer)
end

local __buffer_mt = { __index = debuglib, __tostring = table.concat,
    __newindex = function() error("buffer can't be changed", 2) end
}
__buffer_mt.__metatable = __buffer_mt.__metatable


function debuglib.new_buffer(settings)

    assert(type(settings) == 'table', "argument #1 must be a table")

    table.include(settings, {
        depth_limit = debuglib.recursion_limit,
        separator = ' ',
        indent = '',
        root = '_'
    })

    assert(type(settings.depth_limit) == 'number', "argument #1's depth_limit field must be a number")
    assert(type(settings.separator) == 'string', "argument #1's separator field must be a string")
    assert(type(settings.indent) == 'string', "argument #1's indent field must be a string")
    assert(type(settings.root) == 'string', "argument #1's root field must be a string")

    local res = table.overwrite({
        seen_tables = {
            [_ENV] = '_ENV', 
            [table.null] = 'table.null',
            [table.emptyset] = 'table.emptyset',
        },
        path = {},
        count = 0,
    }, settings)

    setmetatable(res, __buffer_mt)
    return res
end

function debuglib.print(buffer, ...)
    local args = { ... }
    table.append(buffer, args)
end

local function print_tostring(buffer, data)
    buffer:print(tostring(data))
end

debuglib.print_number = print_tostring
debuglib.print_boolean = print_tostring
debuglib.print_nil = print_tostring
debuglib.print_nil = print_tostring

function debuglib.print_any(buffer, data, name)  

    if name ~= nil then
        table.insert(buffer.path, name)
    end

    debuglib['print_' .. type(data)](buffer, data)

    if name ~= nil then
        table.remove(buffer.path)
    end
end

function debuglib.print_string(buffer, data)
    buffer.count = buffer.count + 1
    buffer:print(string.format("%q", data))
end


function debuglib.print_function(buffer, data) 
    buffer.count = buffer.count + 1
    if buffer.serialize then
        buffer:print("function() end")
    else
        buffer:print(debuglib.function_signature(data))
    end
end

function debuglib.print_table(buffer, data)
    buffer.count = buffer.count + 1

    if buffer.seen_tables[data] then
        buffer:print(buffer.seen_tables[data])
        return
    else
        buffer.seen_tables[data] = utils.tablepath(buffer.root, buffer.path)
        utils.tablepath(buffer.root, buffer.path)
    end

    if table.is_empty(data) then
        buffer:print("{}")
        return
    end

    if #buffer.path >= buffer.depth_limit then
        buffer:print('{ --[[ ... ]] }')
        return
    end

    local restore = {}
    if buffer:small_table(data) then
        restore = { indent = buffer.indent, separator = buffer.separator, depth_limit = buffer.depth_limit }
        table.replace(buffer, buffer.small)
        buffer.depth_limit = buffer.depth_limit + 1
    end


    local has_array = table.has_array(data)
    local has_assoc = table.has_assoc(data)

    buffer:print('{', buffer.separator)

    if has_array and has_assoc then
        buffer:print_elements(data)
        buffer:print(',', buffer.separator)
        buffer:print_keyval_pairs(data)
    elseif has_array then
        buffer:print_elements(data)
    elseif has_assoc then 
        buffer:print_keyval_pairs(data)
    end

    buffer:print(buffer.separator, buffer.indent:rep(#buffer.path), "}")
    table.replace(buffer, restore)
end

function debuglib.print_elements(buffer, data)

    local first = true
    for i, v in ipairs(data) do

        if not first then
            buffer:print(',', buffer.separator)
        end

        buffer:print(buffer.indent:rep(#buffer.path + 1))

        buffer:print_any(v, i)

        first = false
        ::continue::
    end
end

function debuglib.print_keyval_pairs(buffer, data)

    local first = true

    for k, v in table.opairs(data, buffer.seen_tables) do
        if k == '__buffer_bare_keys' then goto continue end
        if not first then
            buffer:print(',', buffer.separator)
        end

        buffer:print(buffer.indent:rep(#buffer.path + 1))
        if not rawget(data, '__buffer_bare_keys') then
            buffer:print(utils.tableindex(k, true), ' = ')
        else
            buffer:print(k, ' = ')
        end

        buffer:print_any(v, k)

        first = false
        ::continue::
    end

end

function debuglib.small_table(buffer, tbl)

    if not rawget(buffer, 'small') then return false end

    return
        table.size(tbl) <= buffer.small.size and
        table.all(tbl, function(v, k) return
            (type(v) == 'string' or type(v) == 'number') and
            (type(k) == 'string' or type(k) == 'number')
        end) and
        math.sum(table.collect(tbl, function(v, k)
            return #tostring(k) + #tostring(v)
        end)) <= buffer.small.length
end

local read_files = {}
local seen_functions = {}
function debuglib.function_signature(func, short)

    if seen_functions[func] then
        return seen_functions[func]
    end

    local info = debug.getinfo(func)
    local signature = 'function()'
    local origin = ' ' .. info.short_src .. ':' .. info.linedefined

    if short then
        origin = ''
    end

    if debuglib.io.open then
        if not read_files[info.short_src] and info.short_src then
        local read_lines = {}
        local file = debuglib.io.open(info.short_src)
        if file then
            for l in file:lines() do
                table.insert(read_lines, l)
            end
                file:close()
                file = nil
                read_files[info.short_src] = read_lines
            end
        end
    end

    if read_files[info.short_src] then
        local line = read_files[info.short_src][info.linedefined]
        local args = string.match(line, '%(.*%)') or '()'
        local arg_count = #(string.gsub(string.gsub(line, '[a-zA-Z_][a-zA-Z0-9_.]*', 'x'), '[^x]', ''))

        local decl_as = string.match(line, 'local%s+function%s*') or string.match(line, 'function%s*')
        local name = string.sub(line, string.find(line, decl_as) + #decl_as, (string.find(line, '%s*%(') or #line + 1) - 1)
        local scope = ''

        if string.match(name, '^%s*$') then
            scope = 'function'
        elseif string.match(decl_as, 'local') then
            scope = 'local function '
        elseif not string.find(name, '%.') then
            scope = 'global function '
        elseif name:match('_ENV%.') then
            name = string.gsub(name, '_ENV%.', '')
            scope = 'global function '
        else
            scope = 'function '
        end

        if short then
            scope = string.gsub(scope, 'function ', '')
        end

        signature = scope .. name .. '(' .. arg_count .. ') ' .. origin
    elseif info.namewhat ~= '' then
        signature = info.namewhat .. ' ' .. info.name .. '()'
    end

    seen_functions[func] = signature

    return signature
     
end

return debuglib:seal()