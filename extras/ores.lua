require 'prelude'

local ores = namespace 'extras.ores'

ores.enabled = true

function ores.data()
    if not ores.enabled then return end

    data:extend{
        require 'extras.ores.sulfur-ore',
        table.unpack(
            require 'extras.ores.sulfur-ore-noise-expressions'
        )
    }
end

function ores.data_updates()
    if not ores.enabled then return end

    local name = fns 'sulfur-ore'

    local noise_expressions = data.raw['noise-expression']

    -- Dynamically assign patch set indices for sulfur ore
    -- Claim the next available regular patch set index
    local regular_counts = noise_expressions.default_regular_resource_patch_set_count

    noise_expressions[fns 'sulfur-ore-regular-index'].expression = regular_counts.expression
    regular_counts.expression = regular_counts.expression + 1

    regular_counts = nil

    -- If earlygame enabled, sulfur spawns in starting area; claim a starting index too
    if when('extras.drills', 'tweaks.earlygame') then
        local starting_counts = noise_expressions.default_starting_resource_patch_set_count
        noise_expressions[fns 'sulfur-ore-starting-index'].expression = starting_counts.expression
        starting_counts.expression = starting_counts.expression + 1
    end

    -- Add belt picture variations to vanilla sulfur item
    data.raw.item.sulfur.pictures = table.map(
        {
            '__base__/graphics/icons/sulfur.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-1.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-2.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-3.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-4.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-5.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-6.png',
            '__FeedsNSpeeds__/graphics/item/sulfur-7.png',
        },
        function(filename) return {
            filename = filename,
            mipmap_count = 4,
            scale = 0.5,
            size = 64,
        } end
    )

    -- Register sulfur ore with Nauvis map generation
    data.raw.planet.nauvis.map_gen_settings.autoplace_controls[fns 'sulfur-ore'] = {}
    data.raw.planet.nauvis.map_gen_settings.autoplace_settings.entity.settings[fns 'sulfur-ore'] = {}

    -- If drills module is disabled, provide alternate path to fluid mining
    if not when('extras.drills') then
        
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