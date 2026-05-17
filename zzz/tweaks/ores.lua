
local ores = namespace 'tweaks.ores'

ores.enabled = true

function ores.data_updates()

    if not ores.enabled then return end

    for _, resource in pairs(data.raw.resource) do

        resource.infinite_depletion_amount = 0

        if resource.category == nil or resource.category == 'basic-solid' or resource.category == 'hard-solid' then

            resource.infinite = true
            
            resource.normal = 100
            resource.minimum = 100
            
            resource.stage_counts = { 600, 400, 300, 150, 100, 50, 25, 17 }

            local richness_multiplier_setting = "var('control:" .. resource.name .. ":richness')"

            -- Random noise in the 95% to 105% range
            local random_noise =
              'floor(random_penalty_between{from=95,to=105.999,seed=42069})'
            
            resource.autoplace.richness_expression = random_noise .." * " .. richness_multiplier_setting
        end
    end

    ores.fix_starting_patch_shape('default-iron-ore-patches')
    ores.fix_starting_patch_shape('default-copper-ore-patches')
    ores.fix_starting_patch_shape('default-coal-patches')
    ores.fix_starting_patch_shape('default-stone-patches')
    ores.fix_starting_patch_shape('default-uranium-ore-patches')
    ores.fix_starting_patch_shape(fns 'sulfur-ore-patches')
end

function ores.fix_starting_patch_shape(name)
    local noise = data.raw['noise-expression'][name] or error('No such noise expression ' .. name)
    local expr = noise.expression

    local mult = expr:match('starting_blob_amplitude_multiplier%s*=%s*%d+%.%d+')
    local mult_num = tonumber(mult:match('%d+%.%d+')) / 1.5
    local new_mult = mult:gsub('%d+%.%d+', tostring(mult_num))
    expr = expr:gsub(mult, new_mult)

    noise.expression = expr
end


return seal_namespace(ores)