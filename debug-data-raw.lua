require 'testlib'

require 'debuglib'
require 'prelude'

require 'tweaks'

args = table.pack( ... )

last = table.remove(args, #args)
if not (last:match('%[') and last:match('%]')) then
    last = last:gsub('%-', '%%-')
end

tbl = table.descend(data.raw, table.unpack(args))

new = {}

for k, v in pairs(tbl) do
    if type(k) == 'string' and k:match(last) then
        new[k] = v
    end
end

log(debuglib.sprint(new))
