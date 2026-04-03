require 'prelude'

local debuglib = namespace('debuglib')

function debuglib.sprint(data, path)
  buffer = debuglib.__new_buffer()
  buffer:__sprint_any(data, path)
  return tostring(buffer)
end

debuglib.recursion_limit = tonumber(os and os.getenv('DEPTH')) or 2

function debuglib.__new_buffer(path)
  local res = {
    indent = 0,
    max_indent = debuglib.recursion_limit or 2,
    seen_tables = { [_G] = '_G' },
    path_list = path and { path } or {},
  }
  setmetatable(res, debuglib.__mt)
  return res
end

debuglib.__mt = { __index = debuglib, __tostring = table.concat }

debuglib.__push = table.insert

function debuglib.__render_path(buffer)
  local res = nil
  for _, k in ipairs(buffer.path_list) do
    if res == nil then
      res = k
    elseif type(k) == 'number' then
      res = res .. '[' .. tostring(k) .. ']'
    elseif k[1] == '[' then
      res = res .. k
    else
      res = res .. '.' .. k
    end
  end
  return res
end

function debuglib.__sprint_any(buffer, data, name)  
  if name ~= nil then
    table.insert(buffer.path_list, name)
  end

  debuglib['__sprint_' .. type(data)](buffer, data)

  if name ~= nil then
    table.remove(buffer.path_list)
  end
end

function debuglib.__sprint_function(buffer, data)
  buffer:__push("function() --[[ ... ]] end")
end

function debuglib.__sprint_userdata(buffer, data)
  buffer:__push("--[[ userdata not supported ]] nil")
end

function debuglib.__sprint_string(buffer, data)
  buffer:__push(debuglib.__render_string(data))
end

function debuglib.__sprint_tostring(buffer, data)
  buffer:__push(tostring(data))
end

debuglib.__sprint_number = debuglib.__sprint_tostring
debuglib.__sprint_boolean = debuglib.__sprint_tostring
debuglib.__sprint_nil = debuglib.__sprint_tostring

function debuglib.__sprint_coroutine(buffer, data)
  buffer:__push("--[[ coroutine ]] function() ... end")
end

function debuglib.__sprint_table(buffer, data)

  if buffer.seen_tables[data] then
    buffer:__push("{ --[[ " .. buffer.seen_tables[data] .. " ]] }")
    return
  else
    buffer.seen_tables[data] = buffer:__render_path()
  end

  local is_array = table.is_array(data)
  local is_hash = table.is_hash(data)

  if not (is_array or is_hash) then
    buffer:__push("{}")
    return
  end

  if buffer.indent >= debuglib.recursion_limit then
    buffer:__push('{ --[[ ... ]] }')
    return
  end

  buffer:__push('{\n')

  buffer.indent = buffer.indent + 1

  if is_array and is_hash then
    
    debuglib.__sprint_elements(buffer, data)
    
    buffer:__push(',\n')
    
    debuglib.__sprint_keyval_pairs(buffer, data)

  elseif is_array then
    
    debuglib.__sprint_elements(buffer, data)
  
  elseif is_hash then 
    
    debuglib.__sprint_keyval_pairs(buffer, data)

  end

  buffer.indent = buffer.indent - 1

  buffer:__push('\n' .. string.rep('  ', buffer.indent) .. "}")

end

function debuglib.__sprint_elements(buffer, data)
  local first = true
  for i, v in ipairs(data) do

    if not first then
      buffer:__push(',\n')
    end

    buffer:__push(string.rep('  ', buffer.indent))

    buffer:__sprint_any(v, i)

    first = false
  end
end

function debuglib.__sprint_keyval_pairs(buffer, data)

  local order = {
    insert = table.insert,
    sort = table.sort
  }

  for k, _ in pairs(data) do
    if type(k) == 'string' then
      order:insert(k)
    end
  end

  order:sort()

  local first = true

  for i, k in ipairs(order) do

    v = data[k]

    if not first then
      buffer:__push(',\n')
    end

    buffer:__push(string.rep('  ', buffer.indent) .. debuglib.__render_key(k) .. ' = ')
    buffer:__sprint_any(v, k, i)

    first = false
  end
end

function debuglib.__render_key(data)
  if type(data) == 'number' then
    return "['" .. data .. "']"
  end

  if type(data) ~= 'string' then
    error('not a valid table key for debuglib', data)
  end

  if data:match('^%s*[a-zA-Z_][a-zA-Z_0-9]*%s*$') then
    return data
  else
    return '[' .. debuglib.__render_string(data) .. ']'
  end
end

function debuglib.__render_string(data)
  local sq = data:match("'")
  local dq = data:match('"')
  local nl = data:match('\n')
  if (sq and dq) or nl then
    if data:math('^%[') or data:match('%]$') or data:match('%]%]') or data:match('%[%[') then
      return " [=[" .. data .. "]=] "
    else
      return " [[" .. data .. "]] "
    end
  elseif sq then
    return '"' .. data .. '"'
  else
    return "'" .. data .. "'"
  end
end

return debuglib:__seal()