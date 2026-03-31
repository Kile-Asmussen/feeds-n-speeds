require 'prelude'

tweaks = tweaks or {}
tweaks.ores = tweaks.ores or {}

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

            -- Make the ores infinite
            resource.infinite = true
            
            resource.normal = 100
            resource.minimum = 1
            
            resource.minable.mining_time = 1
            
            resource.stage_counts = { 600, 400, 300, 150, 100, 50, 25, 17 }
            
            richness_multiplier_setting = "control-setting:" .. resource.name .. ":richness:multiplier"
            log("RICHNESS" ..
                debuglib.sprint(tweaks.ores.richness_expression(richness_mult))
            )
        end
    end 
end

function tweaks.ores.richness_expression(varname)
    return {
        type = 'function-application',
        function_name = 'multiply',
        source_location = { filename = "", line_number = 0 },
        arguments = {
            {
                literal_value = 100,
                source_location = { filename = "", line_number = 0 },
                type = 'literal-number'
            },
            {
                variable_name = varname,
                source_location = { filename = "", line_number = 0 },
                type = 'variable'
            }
        }
    }    
end