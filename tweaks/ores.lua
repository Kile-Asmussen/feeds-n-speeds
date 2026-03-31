require 'prelude'

namespace().tweaks.ores = {}

tweaks.ores.toggle = 'feeds-n-speeds-tweaks-ores-enable'
tweaks.ores.enabled_by_default = true

function tweaks.ores.data_final_fixes()

    if not tweaks.ores.enabled then
        log("Ore tweaks disabled")
        return
    end

    log("Ore tweaks enabled")

    for _, resource in pairs(data.raw.resource) do

        resource.infinite_depletion_amount = 0

        if resource.category == nil or resource.category == 'basic-solid' then

            resource.infinite = true
            
            resource.normal = 100
            resource.minimum = 100
             
            resource.minable.mining_time = 1
            
            resource.stage_counts = { 600, 400, 300, 150, 100, 50, 25, 17 }

            local richness_multiplier_setting = "control:" .. resource.name .. ":richness"
            
            resource.autoplace.richness_expression = "100 * var('" .. richness_multiplier_setting .. "')"
        end
    end 
end