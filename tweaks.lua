require('utils')

tweaks = tweaks or {}

require('tweaks-concrete')
require('tweaks-inserters')
require('tweaks-nuclear')
require('tweaks-chests')

function tweaks.data_update()
    for _, domain in pairs(tweaks) do
        if type(domain) == 'table' and type(domain.data_update) == 'function' then
            domain.data_update()
        end
    end
end

-- function tweaks.control()
--     for _, domain in pairs(tweaks) do
--         if type(domain) == 'table' and type(domain.data_update) == 'function' then
--             domain.data_update()
--         end
--     end
-- end




