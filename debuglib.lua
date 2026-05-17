
local debuglib = namespace 'debuglib'

debuglib.recursion_limit = 2
debuglib.serialize = false
debuglib.seen_tables = { [_ENV] = '_ENV' }

debuglib.io = _ENV.io and { open = _ENV.io.open } or {}

function debuglib.pp(data, root)
    local settings = {
        depth_limit = debuglib.recursion_limit or 2,
        func_names = debuglib.serialize,
        indent = '  ',
        separator = '\n',
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



function debuglib.new_buffer(settings)

     assert(type(settings) == 'table', "argument #1 must be a table")
     assert(type(settings.depth_limit) == 'number', "argument #1's depth_limit field must be a number")
     assert(type(settings.separator) == 'string', "argument #1's separator field must be a string")
     assert(type(settings.indent) == 'string', "argument #1's indent field must be a string")
     assert(type(settings.root) == 'string', "argument #1's root field must be a string")

     local res = table.include({
             seen_tables = { [_ENV] = '_ENV', [table.null] = 'table.null' },
             path = {}
     }, settings)

     table.setmetatable(res, debuglib.__buffer_mt)
     return res
end

function debuglib.print(buffer, ...)
     local args = { ... }
     table.append(buffer, args)
end

debuglib.__buffer_mt = { __index = debuglib, __tostring = table.concat }
debuglib.__buffer_mt.__metatable = debuglib.__buffer_mt.__metatable


local function print_tostring(buffer, data)
     buffer:print(tostring(data))
end

function debuglib.print_any(buffer, data, name)  

    if name ~= nil then
        table.insert(buffer.path, name)
    end

    (debuglib['print_' .. type(data)] or print_tostring)(buffer, data)

    if name ~= nil then
        table.remove(buffer.path)
    end
end

function debuglib.print_string(buffer, data)
     buffer:print(string.repr(data))
end


debuglib.IDENTIFIER = '[a-zA-Z_][a-zA-Z0-9_.]*'

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
        local args = line:match('%(.*%)') or '()'
        local arg_count = #(args:gsub(debuglib.IDENTIFIER, 'x'):gsub('[^x]', ''))

        local decl_as = line:match('local%s+function%s*') or line:match('function%s*')
        local name = line:sub(line:find(decl_as) + #decl_as, (line:find('%s*%(') or #line + 1) - 1)
        local scope = ''

        if name:match('^%s*$') then
            scope = 'function'
        elseif decl_as:match('local') then
            scope = 'local function '
        elseif not name:find('%.') then
            scope = 'global function '
        elseif name:match('_ENV%.') then
            name = name:gsub('_ENV%.', '')
            scope = 'global function '
        else
            scope = 'function '
        end

        if short then
            scope = scope:gsub('function ', '')
        end

        signature = scope .. name .. '(' .. arg_count .. ') ' .. origin
    elseif info.namewhat ~= '' then
        signature = info.namewhat .. ' ' .. info.name .. '()'
    end

    seen_functions[func] = signature

    return signature
     
end

function debuglib.print_function(buffer, data) 
    if buffer.serialize then
        buffer:print("function() end")
    else
        buffer:print(debuglib.function_signature(data))
    end
end

function debuglib.print_table(buffer, data)

    if buffer.seen_tables[data] then
        buffer:print(buffer.seen_tables[data])
        return
    else
        buffer.seen_tables[data] = string.tablepath(buffer.root, buffer.path)
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
        table.overwrite(buffer, buffer.small)
        buffer.depth_limit = buffer.depth_limit + 1
    end


    local has_array = table.has_array(data)
    local has_assoc = table.has_assoc(data)

    buffer:print('{', buffer.separator)

    if has_array and has_assoc then
        
        debuglib.print_elements(buffer, data)
        
        buffer:print(',', buffer.separator)
        
        debuglib.print_keyval_pairs(buffer, data)

    elseif has_array then

        debuglib.print_elements(buffer, data)

    elseif has_assoc then 
        
        debuglib.print_keyval_pairs(buffer, data)

    end

    buffer:print(buffer.separator, string.rep(buffer.indent, #buffer.path), "}")
    table.overwrite(buffer, restore)

end

function debuglib.print_elements(buffer, data)

    local first = true
    for i, v in ipairs(data) do

        if not first then
            buffer:print(',', buffer.separator)
        end

        buffer:print(string.rep(buffer.indent, #buffer.path + 1))

        buffer:print_any(v, i)

        first = false
    end
end

function debuglib.print_keyval_pairs(buffer, data)

    local first = true

    for k, v in opairs(data) do

        if not first then
            buffer:print(',', buffer.separator)
        end

        buffer:print(string.rep(buffer.indent, #buffer.path + 1), string.tableindex(k, true), ' = ')
        buffer:print_any(v, k)

        first = false
    end

end

function debuglib.small_table(buffer, tbl)

    if not buffer.small then return false end

    return
        table.size(tbl) <= buffer.small.size and
        table.pall(tbl, function(v, k) return
            (type(v) == 'string' or type(v) == 'number') and
            (type(k) == 'string' or type(k) == 'number')
        end) and
        table.sum(table.collect(tbl, function(v, k)
            return #tostring(k) + #tostring(v)
        end)) <= buffer.small.length
end

return seal_namespace(debuglib)