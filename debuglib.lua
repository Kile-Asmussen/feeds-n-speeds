require 'prelude'

local setmetatable = _G.setmetatable
local getmetatable = _G.getmetatable

local debuglib = namespace 'debuglib'

debuglib.io = namespace 'debuglib.io'
debuglib.io.open = _G.io and _G.io.open
debuglib.io:__seal()

function debuglib.pp(data, root)
    root = root or '_'
    buffer = debuglib.new_buffer(root)
    buffer:print_any(data)
    return tostring(buffer)
end

debuglib.recursion_limit = 2

function debuglib.new_buffer(root)
    local res = {
        indent = 0,
        root = root,
        max_indent = debuglib.recursion_limit or 2,
        seen_tables = { [_G] = '_G' },
        path = {},
    }
    setmetatable(res, debuglib.__buffer_mt)
    return res
end

function debuglib.print(buffer, ...)
    local args = table.pack(...)
    table.append(buffer, args)
end

debuglib.__buffer_mt = { __index = debuglib, __tostring = table.concat }
debuglib.__buffer_mt.__metatable = debuglib.__buffer_mt.__metatable

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
    buffer:print(string.repr(data))
end

local function print_tostring(buffer, data)
    buffer:print(tostring(data))
end

debuglib.print_number = print_tostring
debuglib.print_boolean = print_tostring
debuglib.print_nil = print_tostring
debuglib.print_userdata = print_tostring
debuglib.print_coroutine = print_tostring
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
        elseif name:match('_G%.') then
            name = name:gsub('_G%.', '')
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
    buffer:print(debuglib.function_signature(data))
end

function debuglib.print_table(buffer, data)

  if buffer.seen_tables[data] then
    buffer:print(buffer.seen_tables[data])
    return
  else
    buffer.seen_tables[data] = string.tablepath(buffer.root, buffer.path)
  end

  local is_array = table.is_array(data)
  local is_hash = table.is_hash(data)

  if not (is_array or is_hash) then
    buffer:print("{}")
    return
  end

  if buffer.indent >= debuglib.recursion_limit then
    buffer:print('{ --[[ ... ]] }')
    return
  end

  buffer:print('{\n')

  buffer.indent = buffer.indent + 1

  if is_array and is_hash then
    
    debuglib.print_elements(buffer, data)
    
    buffer:print(',\n')
    
    debuglib.print_keyval_pairs(buffer, data)

  elseif is_array then
    
    debuglib.print_elements(buffer, data)
  
  elseif is_hash then 
    
    debuglib.print_keyval_pairs(buffer, data)

  end

  buffer.indent = buffer.indent - 1

  buffer:print('\n' .. string.rep('  ', buffer.indent) .. "}")

end

function debuglib.print_elements(buffer, data)
  local first = true
  for i, v in ipairs(data) do

    if not first then
      buffer:print(',\n')
    end

    buffer:print(string.rep('  ', buffer.indent))

    buffer:print_any(v, i)

    first = false
  end
end

function debuglib.print_keyval_pairs(buffer, data)

  local first = true

  for i, k in ipairs(table.sorted_keys(data, 'string')) do

    v = data[k]

    if not first then
      buffer:print(',\n')
    end

    buffer:print(string.rep('  ', buffer.indent) .. string.tableindex(k, true) .. ' = ')
    buffer:print_any(v, k, i)

    first = false
  end
end

return debuglib:__seal()