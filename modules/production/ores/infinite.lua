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

        local richness_multiplier_setting = "var('control:" .. resource.name .. ":richness')"
        local random_noise = '(floor(random_penalty_between{from=90,to=110.999,seed=42069}) / 100)'

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
        -- Fluid resources are left at vanilla richness (flow rate yield). Notes:
        -- - fluorine-vent, lithium-brine: richness via aquilo_flourine/lithium_brine_richness,
        --   referenced directly in autoplace.richness_expression; prototype field is authoritative.
        -- - crude-oil on Aquilo: overridden via property_expression_names["entity:crude-oil:richness"]
        --   → aquilo_crude_oil_richness. Nauvis crude-oil uses the prototype field directly.
        -- - sulfuric-acid-geyser on Vulcanus: overridden via property_expression_names, uses
        --   vulcanus_starting_area_multiplier (same low-spawn suppression as calcite/tungsten).
        --   Left as vanilla intentionally for now.
    end
end

for _, planet in pairs(data.raw.planet) do
    local exprs = planet.map_gen_settings and planet.map_gen_settings.property_expression_names
    if exprs then
        for key in pairs(exprs) do
            if key:sub(1, 7) == 'entity:' and key:sub(-9) == ':richness' then
                exprs[key] = nil
            end
        end
    end
end

data.raw.resource['lithium-brine'].infinite = true
data.raw.resource['lithium-brine'].minimum = data.raw.resource['fluorine-vent'].minimum
data.raw.resource['lithium-brine'].maximum = data.raw.resource['fluorine-vent'].maximum
