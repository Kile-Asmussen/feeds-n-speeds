require 'prelude'

local ores = namespace('tweaks.ores')

ores.toggle = 'feeds-n-speeds-tweaks-ores-enable'
ores.enabled = true

function ores.data_final_fixes()

    if not ores.enabled then return end

    for _, resource in pairs(data.raw.resource) do

        resource.infinite_depletion_amount = 0

        if resource.category == nil or resource.category == 'basic-solid' then

            resource.infinite = true
            
            resource.normal = 100
            resource.minimum = 100
             
            resource.minable.mining_time = 1
            
            resource.stage_counts = { 600, 400, 300, 150, 100, 50, 25, 17 }

            local richness_multiplier_setting = "var('control:" .. resource.name .. ":richness')"

            -- Random noise in the 95% to 105% range
            local random_noise =
              'floor(random_penalty_between{from=95,to=105.999})'
            
            resource.autoplace.richness_expression = random_noise .." * " .. richness_multiplier_setting
        end
    end 
end

return ores:__seal()