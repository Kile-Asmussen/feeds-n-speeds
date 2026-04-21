require 'prelude'

local utilities = namespace 'extras.utilities'

function utilities.resource_autoplace_all_patches(tbl)

    return table.concat{
        "resource_autoplace_all_patches{",
        "frequency_multiplier=var('control:", tbl.name, ":frequency),",
        "size_multiplier = var('control:", tbl.name, ":size'),",
        "starting_patch_set_index = ", tbl.starting_patch_set_index, ",",
        "regular_patch_set_index=", tbl.regular_patch_set_index, ",",
        "base_density=", tbl.base_density or 8, ",",
        "base_spots_per_km2=", tbl.base_spots_per_km2 or 1.5, ",",
        "candidate_spot_count=", tbl.candidate_spot_count or 22, ",",
        "has_starting_area_placement=", tbl.has_starting_area or 0, ",",
        "random_spot_size_minimum=", tbl.random_spot_size_minimum or 0.25, ",",
        "random_spot_size_maximum=", tbl.random_spot_size_maximum or 2, ",",
        "regular_blob_amplitude_multiplier=", tbl.regular_blob_amplitude_multiplier or 0.125, ",",
        "regular_patch_set_count=", tbl.regular_patch_set_count or "default_regular_resource_patch_set_count", ",",
        "regular_rq_factor=", tbl.regular_rq_factor or 0.11, ",",
        "seed1=", tbl.seed1 or 400, ",",
        "starting_blob_amplitude_multiplier=", tbl.starting_blob_amplitude_multiplier or 0.125, ",",
        "starting_patch_set_count=", tbl.starting_patch_set_count or "default_starting_resource_patch_set_count", ",",
        "starting_rq_factor=", tbl.starting_rq_factor or 0.21428571428571, "}",
    }

end

return utilities:__seal()