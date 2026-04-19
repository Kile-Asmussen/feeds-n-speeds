require 'prelude'

local ores = namespace 'extras.ores'

ores.enabled = true

function ores.data()
    if not ores.enabled then return end

    data:extend{
        require 'extras.ores.sulfur-ore',
        require 'extras.ores.sulfur-ore-autoplace-control',
        require 'extras.ores.sulfur-ore-noise-expression',
    }
end

function ores.data_updates()
    if not ores.enabled then return end

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
    local nauvis = data.raw.planet.nauvis
    if nauvis and nauvis.map_gen_settings then
        nauvis.map_gen_settings.autoplace_controls[fns 'sulfur-ore'] = {}
    end

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