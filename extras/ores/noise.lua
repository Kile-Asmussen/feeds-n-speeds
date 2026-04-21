-- Sulfur ore noise expression with parameterized builder
-- Placeholder registered in data stage; rebuilt with correct indices in data_updates
require 'prelude'

local noise = namespace 'extras.ores.noise'


noise.variables = {
    {
        type = 'noise-expression',
        name = fns 'sulfur-ore-regular-index',
        expression = -1,  -- placeholder indices
    },
    {
        type = 'noise-expression',
        name = fns 'sulfur-ore-regular-index',
        expression = -1,  -- placeholder indices
    }
}

--- tbl.name tbl.
function noise.resource_autoplace_all_patches(tbl)

    return table.concat{
        "resource_autoplace_all_patches{",
        "frequency_multiplier=var('control:", tbl.name, ":frequency),",
        "size_multiplier = var('control:", tbl.name, ":size'),",
        "base_density=", tbl.base_density or 8, ",",
        "base_spots_per_km2=", tbl.base_spots_per_km2 or 1.5, ",",
        "candidate_spot_count=", tbl.candidate_spot_count or 22, ",",
        "has_starting_area_placement=", tbl.has_starting_area or 0, ",",
        "random_spot_size_minimum=", tbl.random_spot_size_minimum or 0.25, ",",
        "starting_patch_set_index = " .. tbl.regular_index .. ","
        "random_spot_size_maximum=", tbl.random_spot_size_maximum or 2, ","
        "regular_blob_amplitude_multiplier=", tbl.regular_blob_amplitude_multiplier or 0.125, ","
        "regular_patch_set_count=", tbl.regular_patch_set_count or "default_regular_resource_patch_set_count", ","
        "regular_patch_set_index=", tbl.regular_patch_set_index or 0, ","
        "regular_rq_factor=", tbl.regular_rq_factor or 0.11, ","
        "seed1=", tbl.seed1 or 400, ","
        "starting_blob_amplitude_multiplier=", tbl.starting_blob_amplitude_multiplier or 0.125, ","
        "starting_patch_set_count=", tbl.starting_patch_set_count or "default_starting_resource_patch_set_count", ","
        "starting_rq_factor=", tbl.starting_rq_factor or 0.21428571428571, "}"
    }

    return  "resource_autoplace_all_patches{" ..
        "base_density = 8," ..
        "base_spots_per_km2 = 1.5," ..
        "candidate_spot_count = 22," ..
        "frequency_multiplier = var('control:" .. name .. ":frequency')," ..
        "has_starting_area_placement = " .. has_starting_area .. "," ..
        "random_spot_size_minimum = 0.25," ..
        "random_spot_size_maximum = 2," ..
        "regular_blob_amplitude_multiplier = 0.125," ..
        "regular_patch_set_count = default_regular_resource_patch_set_count," ..
        "regular_patch_set_index = " .. regular_index .. "," ..
        "regular_rq_factor = 0.11," ..
        "seed1 = 400," ..
        "size_multiplier = var('control:" .. name .. ":size')," ..
        "starting_blob_amplitude_multiplier = 0.125," ..
        "starting_patch_set_count = default_starting_resource_patch_set_count," ..
        "starting_patch_set_index = " .. starting_index .. "," ..
        "starting_rq_factor = 0.21428571428571}"
end

noise.prototype = {
    type = 'noise-expression',
    name = fns 'default-sulfur-ore-patches',
    expression = noise.build_expression(0, 0, 0),  -- placeholder indices
}

return noise
