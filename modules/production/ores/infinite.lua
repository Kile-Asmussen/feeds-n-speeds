--! data: make ores infinite
local fns = require 'fns'

if not settings.startup[fns 'infinite-ores'].value then return end

for _, resource in pairs(data.raw.resource) do

    if resource.category == 'basic-solid' or resource.category == 'hard-solid' then
        
        resource.infinite_depletion_amount = 1
        
        resource.infinite = true
        
        resource.normal = 100
        resource.minimum = 100
        
        resource.stage_counts = { 600, 400, 300, 150, 100, 50, 25, 17 }

        local richness_multiplier_setting = "var('control:" .. resource.name .. ":richness')"

        local random_noise =
            'floor(random_penalty_between{from=90,to=110.999,seed=42069})'
        
        resource.autoplace.richness_expression = random_noise .." * " .. richness_multiplier_setting
    end

    if resource.category == 'basic-fluid' then
        resource.infinite = true
    end
end