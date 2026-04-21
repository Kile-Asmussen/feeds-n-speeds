require 'prelude'

local ores = namespace 'extras.ores'
local noise = require 'extras.ores.noise'

ores.enabled = true

function ores.data()
    if not ores.enabled then return end

    -- Note: resource_autoplace.resource_autoplace_settings{} in sulfur-ore.lua
    -- automatically creates noise expression 'default-feeds-n-speeds-sulfur-ore-patches'
    data:extend{
        require 'extras.ores.sulfur-ore',
        require 'extras.ores.sulfur-ore-autoplace-control',
    }
end

function ores.data_updates()
    if not ores.enabled then return end

    local tweaks = import 'tweaks'
    local name = fns 'sulfur-ore'
    local noise_expr_name = 'default-' .. name .. '-patches'

    -- Dynamically assign patch set indices for sulfur ore
    -- Claim the next available regular patch set index
    local regular_counts = data.raw['noise-expression'].default_regular_resource_patch_set_count
    local regular_index = regular_counts.expression
    regular_counts.expression = regular_index + 1

    -- If earlygame enabled, sulfur spawns in starting area; claim a starting index too
    local has_starting_area = tweaks.earlygame.enabled and 1 or 0
    local starting_index = 0
    if tweaks.earlygame.enabled then
        local starting_counts = data.raw['noise-expression'].default_starting_resource_patch_set_count
        starting_index = starting_counts.expression
        starting_counts.expression = starting_index + 1
    end

    -- Rebuild noise expression with correct indices
    data.raw['noise-expression'][noise_expr_name].expression =
        noise.

    -- Add belt picture variations to vanilla sulfur item
    data.raw.item.sulfur.pictures = {
        {
            filename = '__base__/graphics/icons/sulfur.png',
            mipmap_count = 4,
            scale = 0.5,
            size = 64,
        },
        {
            filename = '__FeedsNSpeeds__/graphics/item/sulfur-1.png',
            mipmap_count = 4,
            scale = 0.5,
            size = 64,
        },
        {
            filename = '__FeedsNSpeeds__/graphics/item/sulfur-2.png',
            mipmap_count = 4,
            scale = 0.5,
            size = 64,
        },
        {
            filename = '__FeedsNSpeeds__/graphics/item/sulfur-3.png',
            mipmap_count = 4,
            scale = 0.5,
            size = 64,
        },
        {
            filename = '__FeedsNSpeeds__/graphics/item/sulfur-4.png',
            mipmap_count = 4,
            scale = 0.5,
            size = 64,
        },
        {
            filename = '__FeedsNSpeeds__/graphics/item/sulfur-5.png',
            mipmap_count = 4,
            scale = 0.5,
            size = 64,
        },
        {
            filename = '__FeedsNSpeeds__/graphics/item/sulfur-6.png',
            mipmap_count = 4,
            scale = 0.5,
            size = 64,
        },
        {
            filename = '__FeedsNSpeeds__/graphics/item/sulfur-7.png',
            mipmap_count = 4,
            scale = 0.5,
            size = 64,
        },
    }

    -- Register sulfur ore with Nauvis map generation
    data.raw.planet.nauvis.map_gen_settings.autoplace_controls[fns 'sulfur-ore'] = {}
    data.raw.planet.nauvis.map_gen_settings.autoplace_settings.entity.settings[fns 'sulfur-ore'] = {}

    -- If drills module is disabled, provide alternate path to fluid mining
    local extras = import 'extras'
    if not extras.drills.enabled then
        -- Hide vanilla uranium-mining (mining-with-fluid now from sulfur-drilling)
        data.raw.technology['uranium-mining'].hidden = true

        -- Add sulfur drilling technology
        data:extend{
            require 'extras.ores.sulfur-drilling-technology',
        }

        -- Make uranium-processing depend on sulfur-drilling
        table.insert(data.raw.technology['uranium-processing'].prerequisites,
            fns 'sulfur-drilling'
        )
    end
end

return ores:__seal()