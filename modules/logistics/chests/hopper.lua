
local fns = require 'fns'

local hopper = 
table.merge(table.clone(data.raw.container['steel-chest']), {
    type = 'proxy-container',
    name = fns 'hopper',
    icon = 
})

local hopper = {
    circuit_connector = table.clone(data.raw.container['steel-chest'].circuit_connector),
    type = 'proxy-container',
    
}