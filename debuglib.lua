require 'prelude'

local debuglib = namespace 'debuglib'

debuglib.io = _G.io and { open = _G.io.open } or {}

function debuglib.pp(data, root, rec)
    if not rec and type(root) == 'number' then
        rec = root
        root = nil
    end

    if data == _G then
        data = table.dup(_G)
        root = root or '_G'
    else
        root = root or '_'
    end

    local buffer = debuglib.new_buffer(root, rec)
    buffer:print_any(data)
    return tostring(buffer)
end

debuglib.recursion_limit = 2

function debuglib.new_buffer(root, rec_limit)
    rec_limit = rec_limit or debuglib.recursion_limit or 2
    local res = {
        indent = 0,
        root = root,
        max_indent = rec_limit,
        seen_tables = { [_G] = '_G', [table.null] = 'table.null' },
        path = {},
    }
    table.setmetatable(res, debuglib.__buffer_mt)
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

  if table.is_empty(data) then
    buffer:print("{}")
    return
  end

  if buffer.indent >= buffer.max_indent then
    buffer:print('{ --[[ ... ]] }')
    return
  end


  local has_array = table.has_array(data)
  local has_assoc = table.has_assoc(data)

  buffer:print('{\n')

  buffer.indent = buffer.indent + 1

  if has_array and has_assoc then
    
    debuglib.print_elements(buffer, data)
    
    buffer:print(',\n')
    
    debuglib.print_keyval_pairs(buffer, data)

  elseif has_array then
    
    debuglib.print_elements(buffer, data)
  
  elseif has_assoc then 
    
    debuglib.print_keyval_pairs(buffer, data)

  end

  buffer.indent = buffer.indent - 1

  buffer:print('\n', string.rep('  ', buffer.indent), "}")

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

  local keys = table.sorted_keys(data)

  for i, k in ipairs(keys) do

    local v = data[k]

    if not first then
      buffer:print(',\n')
    end

    buffer:print(string.rep('  ', buffer.indent), string.tableindex(k, true), ' = ')
    buffer:print_any(v, k, i)

    first = false
  end

end

return seal_namespace(debuglib)