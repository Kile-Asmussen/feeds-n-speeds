debug = {}

function debug.print(data, indent)
  indent = indent or 0

  debug.print_depth_limit = debug.print_depth_limit or 1e10
  
  debug.__traversers = debug.__traversers or {
    string = debug.print_string,
    boolean = debug.print_boolean,
    ['nil'] = debug.print_nil,
    number = debug.print_number, 
    table = debug.print_table,
    userdata = debug.print_userdata,
    ['function'] = debug.print_function
  }

  local traverser = debug.__traversers[type(data)]

  if traverser then
    traverser(data, indent)
  else
    io.write("unknown value of " .. type(data))
  end
end

function debug.print_function(data, indent)
  io.write("function() ... end")
end

function debug.print_userdata(data, indent)
  io.write("userdata ")
  local meta = getmetatable(data)
  if meta then
    debug.print(meta, indent + 1)
  end
end

function debug.print_string(data, indent)
  io.write("'" .. data .. "'")
end

function debug.print_number(data, indent)
  io.write(tostring(data))
end

function debug.print_boolean(data, indent)
  if data then io.write("true") else io.write("false") end
end

function debug.print_nil(data, indent)
  io.write("nil")
end

function debug.print_table(data, indent)

  if data == _G and indent > 0 then
    io.write("_G")
    return
  end

  if debug.print_depth_limit < indent then
    io.write("{ ... }")
    return
  end

  local is_array = debug.is_populated_table_array(data)
  local is_hash = debug.is_populated_table_hash(data)

  if is_array and is_hash then

    io.write('{\n')
    
    debug.print_array(data, indent + 1)
    
    io.write(',\n')
    
    debug.print_keyval(data, indent + 1)

    io.write('\n' .. string.rep('  ', indent) .. "}")


  elseif is_array then

    io.write('{\n')
    
    debug.print_array(data, indent + 1)

    io.write('\n' .. string.rep('  ', indent) .. "}")
  
  elseif is_hash then 

    io.write('{\n')
    
    debug.print_keyval(data, indent + 1)

    io.write('\n' .. string.rep('  ', indent) .. "}")

  else
    io.write("{}")
  end

end

function debug.is_populated_table_array(data)
  return #data > 0
end

function debug.is_populated_table_hash(data)
  for k, _ in pairs(data) do
    if type(k) == 'string' then
      return true
    end
  end
  return false
end

function debug.print_array(data, indent)
  local first = true
  for _, v in ipairs(data) do

    if not first then
      io.write(',\n')
    end

    io.write(string.rep('  ', indent))
    debug.print(v, indent)

    first = false
  end
end

function debug.print_keyval(data, indent)

  local order = {}

  for k, _ in pairs(data) do
    if type(k) == 'string' and not string.find(k, "^__") then
      table.insert(order, k)
    end
  end

  table.sort(order)

  local first = true
  for _, k in ipairs(order) do

    v = data[k]

    if not first then
      io.write(',\n')
    end

    if string.find(k, '[^a-zA-Z_]') then
      k = "['" .. k .. "']"
    end

    io.write(string.rep('  ', indent) .. k .. ' = ')
    debug.print(v, indent)

    first = false
  end
end
