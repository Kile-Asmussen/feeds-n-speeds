-- Sulfur ore noise expression with parameterized builder
-- Placeholder registered in data stage; rebuilt with correct indices in data_updates
require 'prelude'

local M = {}

local name = fns 'sulfur-ore'

function M.build_expression(regular_index, starting_index, has_starting_area)
    return "resource_autoplace_all_patches{" ..
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

M.prototype = {
    type = 'noise-expression',
    name = fns 'default-sulfur-ore-patches',
    expression = M.build_expression(0, 0, 0),  -- placeholder indices
}

return M
