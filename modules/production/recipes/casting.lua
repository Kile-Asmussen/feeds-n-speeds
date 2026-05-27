
local fns = require 'fns'
local recipes = data.raw.recipe

recipes['casting-pipe'].allow_productivity = true
recipes['casting-pipe-to-ground'] = nil

table.merge(recipes['casting-iron-stick'], {
    ingredients = {{ type='fluid', name='molten-iron', amount=10 }},
    results = {{ type='item', name='iron-stick', amount=2 }},
})

for _, r in ipairs{
    'casting-pipe',
    'casting-iron-gear-wheel',
    'casting-iron-stick',
    'casting-copper-cable',
} do
    recipes[r].energy_required = 1.6
end

data:extend{
    {
        type = 'recipe',
        name = fns 'casting-engine',
        allow_productivity = true,
        allow_auto_recycle = false,
        auto_unlocked_by = 'foundry',
        enabled = false,
        icons = {
            {
                icon=data.raw.item['engine-unit'].icon,
                scale=0.5,
                shift={-4, 4},
                float=true
            },
            {
                icon='__FeedsNSpeeds__/graphics/icon/iron-casting-icon.png',
                scale=0.33,
                shift={6, -6},
                float=true
            }
        },
        category = 'metallurgy',
        ingredients = {
            { type='fluid', name='molten-iron', amount=60 },
            { type='item', name='steel-plate', amount=3 },
            { type='item', name='iron-gear-wheel', amount=6 },
            { type='item', name='pipe', amount=3 },
        },
        energy_required = 40,
        results = {
            { type='item', name='engine-unit', amount=4 }
        }
    },
    {
        type = 'recipe',
        name = fns 'casting-heat-pipe',
        allow_productivity = true,
        enabled = false,
        allow_auto_recycle = false,
        auto_unlocked_by = 'foundry',
        icons = {
            {
                icon=data.raw.item['heat-pipe'].icon,
                scale=0.5,
                shift={-4, 4},
                float=true
            },
            {
                icon='__FeedsNSpeeds__/graphics/icon/copper-casting-icon.png',
                scale=0.33,
                shift={6, -6},
                float=true
            },
        },
        category = 'metallurgy',
        ingredients = {
            { type='fluid', name='molten-copper', amount=200 },
            { type='item', name='steel-plate', amount=10 },
        },
        energy_required = 8,
        results = {
            { type='item', name='heat-pipe', amount=1 }
        }
    }
}

local function melt_down(item, input, fluid, output)
    local name = fns ('melt-scrap-' .. item);
    data:extend{{
        type = 'recipe',
        name = name,
        enabled = false,
        allow_productivity = false,
        auto_unlocked_by = 'foundry',
        icons = {
            {
                icon=data.raw.item[item].icon,
                scale=0.5,
                shift={-4, -4},
                float=true
            },
            {
                icon='__FeedsNSpeeds__/graphics/icon/iron-casting-icon.png',
                scale=0.5,
                shift={4, 0},
                float=true,
            }
        },
        category = 'metallurgy',
        ingredients = {
            { type='item', name=item, amount=input },
        },
        energy_required = 6.4,
        results = {
            { type='fluid', name=fluid, amount=output }
        }
    }}
end

melt_down('iron-plate', 20, 'molten-iron', 50)
melt_down('iron-gear-wheel', 20, 'molten-iron', 50)
melt_down('copper-plate', 20, 'molten-copper', 50)
melt_down('pipe', 20, 'molten-iron', 50)
melt_down('steel-plate', 20, 'molten-iron', 150)
melt_down('iron-stick', 40, 'molten-iron', 50)
melt_down('copper-cable', 40, 'molten-copper', 50)