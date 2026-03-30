debug = {
  recursion_limit = tonumber(os.getenv("DEPTH")) or 2
}

function debug.print(data)
  print(debug.sprint(data))
end

function debug.buffer()
  return {
    indent = 0,
    max_indent = debug.recursion_limit or 1e10,
    push = table.insert,
    tostring = table.concat,
    print = debug.__sprint_any,
  }
end

function debug.sprint(data)  
  buffer = debug.buffer()
  buffer:print(data)
  return buffer:tostring()
end

function debug.__sprint_any(buffer, data)
  debug.__type_sprinters = debug.__type_sprinters or {
    ['string'] = debug.__sprint_string,
    ['boolean'] = debug.__sprint_boolean,
    ['nil'] = debug.__sprint_nil,
    ['number'] = debug.__sprint_number, 
    ['table'] = debug.__sprint_table,
    ['userdata'] = debug.__sprint_userdata,
    ['coroutine'] = function() return "coroutine()" end,
    ['function'] = debug.__sprint_function,
  }

  local sprinter = debug.__type_sprinters[type(data)]

  if sprinter then
    return sprinter(buffer, data)
  else
    return nil
  end
end

function debug.__sprint_function(buffer, data)
  buffer:push("function() ... end")
end

function debug.__sprint_userdata(buffer, data)
  buffer:push("userdata")

  local meta = getmetatable(data)
  if meta then
    return debug:print(meta)
  end
end

function debug.__sprint_string(buffer, data)
  buffer:push("'" .. data .. "'")
end

function debug.__sprint_number(buffer, data)
  buffer:push(tostring(data))
end

function debug.__sprint_boolean(buffer, data)
  if data then buffer:push("true") else buffer:push("false") end
end

function debug.__sprint_nil(buffer, data)
  buffer:push("nil")
end

function debug.__sprint_table(buffer, data)

  if data == _G and buffer.indent > 0 then
    buffer:push("_G")
    return
  end


  local is_array = debug.is_populated_table_array(data)
  local is_hash = debug.is_populated_table_hash(data)

  if not (is_array or is_hash) then
    buffer:push("{}")
  end

  if buffer.indent >= buffer.max_indent then
    buffer:push("{ ... }")
    return
  end

  buffer:push('{\n')

  buffer.indent = buffer.indent + 1

  if is_array and is_hash then
    
    debug.__sprint_elements(buffer, data)
    
    buffer:push(',\n')
    
    debug.__sprint_keyval_pairs(buffer)

  elseif is_array then
    
    debug.__sprint_elements(buffer, data)
  
  elseif is_hash then 
    
    debug.__sprint_keyval_pairs(buffer, data)

  end

  buffer.indent = buffer.indent - 1

  buffer:push('\n' .. string.rep('  ', buffer.indent) .. "}")

end

function debug.is_populated_table_array(data)
  for _ in ipairs(data) do
      return true
  end
end

function debug.is_populated_table_hash(data)
  for k, _ in pairs(data) do
    if type(k) == 'string' then
      return true
    end
  end
  return false
end

function debug.__sprint_elements(buffer, data)
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

function debug.__sprint_keyval_pairs(buffer, data)

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
