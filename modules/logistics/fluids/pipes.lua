--! data: unhide the three valve prototypes
local fns = require 'fns'
local table = fns.table
local gadgets = fns.gadgets
local inputs = fns.gadgets.throughputs

-- tints matching the logistic chest color language:
--   one-way   -> green-blue (buffer chest: controlled flow)
--   overflow  -> red        (passive provider: drains excess)
--   top-up    -> blue       (requester: fills to threshold)
local valve_tints = {
    ['one-way-valve']  = { r = 0.2, g = 0.8, b = 0.7, a = 0.7 },
    ['overflow-valve'] = { r = 0.9, g = 0.1, b = 0.1, a = 0.7 },
    ['top-up-valve']   = { r = 0.1, g = 0.4, b = 0.9, a = 0.7 },
}

for name, tint in pairs(valve_tints) do
    local entity = data.raw.valve[name]
    local item   = data.raw.item[name]

    entity.hidden = false

    table.merge(item, {
        hidden   = false,
        icons = {
            gadgets.icon(data.raw.pipe.pipe.icon),
            gadgets.floating_icon('topleft', data.raw['virtual-signal']['right-arrow'].icon, { scale = 0.33, tint = tint }),
        },
        __del = 'icon',
        auto_unlocked_by = 'fluid-handling',
    })
end

for name in pairs(valve_tints) do
    data:extend{{
        type             = 'recipe',
        name             = name,
        ingredients      = inputs{ ['copper-plate'] = 2, ['pipe'] = 1 },
        results          = inputs{ [name] = 1 },
        energy_required  = 1,
        enabled          = false,
        auto_unlocked_by = 'fluid-handling',
    }}
end
