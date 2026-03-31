require('prelude')
debuglib = {
  recursion_limit = 2
}


function debuglib.buffer()
  return {
    indent = 0,
    max_indent = debuglib.recursion_limit or 2,
    push = table.insert,
    tostring = table.concat,
    print = debuglib.__sprint_any,
  }
end

function debuglib.sprint(data)  
  buffer = debuglib.buffer()
  buffer:print(data)
  return buffer:tostring()
end

function debuglib.__sprint_any(buffer, data)
  debuglib.__type_sprinters = debuglib.__type_sprinters or {
    ['string'] = debuglib.__sprint_string,
    ['boolean'] = debuglib.__sprint_boolean,
    ['nil'] = debuglib.__sprint_nil,
    ['number'] = debuglib.__sprint_number, 
    ['table'] = debuglib.__sprint_table,
    ['userdata'] = debuglib.__sprint_userdata,
    ['coroutine'] = function() return "coroutine()" end,
    ['function'] = debuglib.__sprint_function,
  }

  local sprinter = debuglib.__type_sprinters[type(data)]

  if sprinter then
    return sprinter(buffer, data)
  else
    return nil
  end
end

function debuglib.__sprint_function(buffer, data)
  buffer:push("function() ... end")
end

function debuglib.__sprint_userdata(buffer, data)
  buffer:push("userdata")

  local meta = getmetatable(data)
  if meta then
    return debuglib.__sprint_table(buffer, meta)
  end
end

function debuglib.__sprint_string(buffer, data)
  buffer:push("'" .. data .. "'")
end

function debuglib.__sprint_number(buffer, data)
  buffer:push(tostring(data))
end

function debuglib.__sprint_boolean(buffer, data)
  if data then buffer:push("true") else buffer:push("false") end
end

function debuglib.__sprint_nil(buffer, data)
  buffer:push("nil")
end

function debuglib.__sprint_table(buffer, data)

  if data == _G and buffer.indent > 0 then
    buffer:push("_G")
    return
  end

  local is_array = debuglib.is_populated_table_array(data)
  local is_hash = debuglib.is_populated_table_hash(data)

  if not (is_array or is_hash) then
    buffer:push("{}")
    return
  end

  if buffer.indent >= debuglib.recursion_limit then
    buffer:push("{ ... }")
    return
  end

  buffer:push('{\n')

  buffer.indent = buffer.indent + 1

  if is_array and is_hash then
    
    debuglib.__sprint_elements(buffer, data)
    
    buffer:push(',\n')
    
    debuglib.__sprint_keyval_pairs(buffer)

  elseif is_array then
    
    debuglib.__sprint_elements(buffer, data)
  
  elseif is_hash then 
    
    debuglib.__sprint_keyval_pairs(buffer, data)

  end

  buffer.indent = buffer.indent - 1

  buffer:push('\n' .. string.rep('  ', buffer.indent) .. "}")

end

function debuglib.is_populated_table_array(data)
  for _ in ipairs(data) do
      return true
  end
end

function debuglib.is_populated_table_hash(data)
  for k, _ in pairs(data) do
    if type(k) == 'string' then
      return true
    end
  end
  return false
end

function debuglib.__sprint_elements(buffer, data)
  local first = true
  for _, v in ipairs(data) do

    if not first then
      buffer:push(',\n')
    end

    buffer:push(string.rep('  ', buffer.indent))

    buffer:print(v)

    first = false
  end
end

function debuglib.__sprint_keyval_pairs(buffer, data)

  local order = {
    insert = table.insert,
    sort = table.sort
  }

  for k, _ in pairs(data) do
    if type(k) == 'string' and not string.find(k, "^__") then
      order:insert(k)
    end
  end

  order:sort()

  local first = true

  for _, k in ipairs(order) do

    v = data[k]

    if not first then
      buffer:push(',\n')
    end

    if string.find(k, '[^a-zA-Z_]') then
      k = "['" .. k .. "']"
    end

    buffer:push(string.rep('  ', buffer.indent) .. k .. ' = ')
    buffer:print(v)

    first = false
  end
end
