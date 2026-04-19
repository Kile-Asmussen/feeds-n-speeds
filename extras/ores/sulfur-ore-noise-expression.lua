require 'prelude'

local tweaks = import 'tweaks'

-- If earlygame is enabled, sulfur spawns in starting area (like iron/copper)
-- If earlygame is disabled, sulfur is a distant resource (like uranium/oil)
local has_starting_area = tweaks.earlygame.enabled and 1 or 0

local name = fns 'sulfur-ore'

return {
    type = 'noise-expression',
    name = fns 'default-sulfur-ore-patches',
    expression = "resource_autoplace_all_patches{base_density = 8,base_spots_per_km2 = 1.5,candidate_spot_count = 22,frequency_multiplier = var('control:" .. name .. ":frequency'),has_starting_area_placement = " .. has_starting_area .. ",random_spot_size_minimum = 0.25,random_spot_size_maximum = 2,regular_blob_amplitude_multiplier = 0.125,regular_patch_set_count = default_regular_resource_patch_set_count,regular_patch_set_index = 3,regular_rq_factor = 0.11,seed1 = 400,size_multiplier = var('control:" .. name .. ":size'),starting_blob_amplitude_multiplier = 0.125,starting_patch_set_count = default_starting_resource_patch_set_count,starting_patch_set_index = 3,starting_rq_factor = 0.21428571428571}",
}
