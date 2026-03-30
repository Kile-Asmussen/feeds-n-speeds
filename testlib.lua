require("data.raw")



settings = { global = {} }
setmetatable(settings.global, {
    __index = function(name) return true end
})

function data.extend(self, proto) 
    -- if self ~= data and proto == nil then
    --     proto = self
    --     self = data
    -- end

    -- assert(type(proto) ~= 'table', "Invalid array of prototypes")


end