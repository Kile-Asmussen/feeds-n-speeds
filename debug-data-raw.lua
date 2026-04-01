require 'prelude'
require 'test-config'

local debuglib = require 'debuglib'
local tweaks = require 'tweaks'

function 

local args = table.pack( ... )

local last = table.remove(args, #args)

local tbl = table.descend(data.raw, table.unpack(args))

if tbl[last] then
    log(debuglib.sprint(tbl[last]))
else
    if not (last:match('%[') and last:match('%]')) then
        last = last:gsub('%-', '%%-')
    end

    new = {}

    for k, v in pairs(tbl) do
        if type(k) == 'string' and k:match(last) then
            new[k] = v
        end
    end
end
