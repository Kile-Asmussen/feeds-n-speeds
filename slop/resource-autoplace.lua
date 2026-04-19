-- Stub for Factorio's resource-autoplace library
-- Place this file at test/resource-autoplace.lua
-- Returns autoplace specification for resources and creates noise expression

local resource_autoplace = namespace 'test.resource-autoplace'

function resource_autoplace.resource_autoplace_settings(params)
    local name = params.name
    local order = params.order or "b"

    -- Build the noise expression name
    local patches_name = "default-" .. name .. "-patches"

    -- Create the noise expression (like vanilla helper does)
    local noise_expr = {
        type = "noise-expression",
        name = patches_name,
        expression = "placeholder",  -- rebuilt in data_updates
    }
    data:extend{ noise_expr }

    -- Return an autoplace specification similar to vanilla
    return {
        order = order,
        probability_expression = "(var('control:" .. name .. ":size') > 0) * (clamp(var('" .. patches_name .. "'), 0, 1))",
        richness_expression = "(var('control:" .. name .. ":size') > 0) * (1*var('control:" .. name .. ":richness')*(var('" .. patches_name .. "'))*max((1000+distance)/2600,1))",
    }
end

return resource_autoplace
