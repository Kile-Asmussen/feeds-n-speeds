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

        resource.stage_counts = fns.table.icollect({
            10,
            7,
            5,
            3.5,
            2.5,
            1.5,
            1.0,
            0.5
         }, function(n) return resource.minimum * n end)

        local distance_start = 300   -- distance (tiles) where richness begins increasing
        local distance_full  = 1500  -- distance (tiles) where richness reaches cap
        local distance_max   = 3     -- richness multiplier cap
        local distance_scale = (distance_full - distance_start) / (distance_max - 1)
        local distance_term  = "clamp((distance - " .. distance_start .. ") / " .. distance_scale .. " + 1, 1, " .. distance_max .. ")"

        if resource.autoplace.richness_expression then
            local richness_multiplier_setting = "var('control:" .. resource.name .. ":richness')"
            local random_noise = '(floor(random_penalty_between{from=90,to=110.999,seed=42069}) / 100)'

            resource.autoplace.richness_expression =
                table.concat({
                    resource.normal,
                    richness_multiplier_setting,
                    random_noise,
                    distance_term
                }, " * ")
        else
            -- Scale factors align planet expression output with resource.normal = 25000.
            -- Derived from the scalar constants in each planet's richness noise expression.
            local planet_scale = {
                vulcanus_calcite_richness     = 25000 / 24000,
                vulcanus_tungsten_ore_richness = 25000 / 10000,
                gleba_stone_richness           = 25000 / 4000,
            }
            local planet_expr_suffix = resource.name:gsub('-', '_') .. "_richness"
            for name in pairs(data.raw['noise-expression']) do
                if name:sub(-#planet_expr_suffix) == planet_expr_suffix then
                    local scale = planet_scale[name] or 1
                    resource.autoplace.richness_expression = name .. " * " .. scale .. " * " .. distance_term
                    break
                end
            end
        end
    end

    if resource.category == 'basic-fluid' then
        resource.infinite = true
    end
end

data.raw.resource['lithium-brine'].infinite = true
data.raw.resource['lithium-brine'].minimum = data.raw.resource['fluorine-vent'].minimum
data.raw.resource['lithium-brine'].maximum = data.raw.resource['fluorine-vent'].maximum
