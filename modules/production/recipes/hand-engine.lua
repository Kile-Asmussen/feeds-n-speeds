--! data: hand-craftable engine unit recipe for early game
local fns = require 'fns'

local hand_engine = table.clone(data.raw.recipe['engine-unit'])
hand_engine.name = fns 'hand-engine-unit'
hand_engine.localised_name = {'item-name.engine-unit'}
hand_engine.category = fns 'hand-crafting'
hand_engine.energy_required = 10
hand_engine.auto_unlocked_by = 'steam-power'

data:extend{ hand_engine }
