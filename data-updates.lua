
require('tweaks')

for name, data in tweaks do
    if data.data_update ~= nil and type(data.data_update) == 'function' then
        data.data_update()
    end
end