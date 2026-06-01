--! data: make ores infinite
local fns = require 'fns'

if not settings.startup[fns 'infinite-ores'].value
then return end

for _, resource in pairs(data.raw.resource) do

    if not resource.category or resource.category == 'hard-solid' then
        
        resource.infinite_depletion_amount = 1
        
        resource.infinite = true
        
        resource.normal = 25000
        resource.minimum = 10000

        resource.stage_counts = { 1500, 1200, 600, 400, 300, 150, 100, 50 }

        local richness_multiplier_setting = "var('control:" .. resource.name .. ":richness')"

        local random_noise =
            '(floor(random_penalty_between{from=90,to=110.999,seed=42069}) / 100)'

        local distance_start = 350   -- distance (tiles) where richness begins increasing
        local distance_full  = 2200  -- distance (tiles) where richness reaches cap
        local distance_max   = 2.5     -- richness multiplier cap
        local distance_scale = (distance_full - distance_start) / (distance_max - 1)
        local distance_term  = "clamp((distance - " .. distance_start .. ") / " .. distance_scale .. " + 1, 1, " .. distance_max .. ")"
        
        resource.autoplace.richness_expression =
            table.concat({
                resource.normal,
                richness_multiplier_setting,
                random_noise,
                distance_term
            }, " * ")
    end

    if resource.category == 'basic-fluid' then
        resource.infinite = true
    end
end

data.raw.resource['lithium-brine'].infinite = true
data.raw.resource['lithium-brine'].minimum = data.raw.resource['fluorine-vent'].minimum
data.raw.resource['lithium-brine'].maximum = data.raw.resource['fluorine-vent'].maximum
