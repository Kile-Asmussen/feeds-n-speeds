require 'prelude'

return {
    {
        type = 'recipe',
        name = fns 'cast-engine',
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
            { type='fluid', name='molten-iron', amount=50 },
            { type='item', name='steel-plate', amount=5 },
            { type='item', name='iron-gear-wheel', amount=5 },
            { type='item', name='pipe', amount=10 },
        },
        energy_required = enabled('tweaks.timewaster') and 20 or 40,
        results = {
            { type='item', name='engine-unit', amount=5 }
        }
    },
    {
        type = 'recipe',
        name = fns 'cast-heat-pipe',
        enabled = false,
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
        energy_required = 1,
        results = {
            { type='item', name='heat-pipe', amount=1 }
        }
    }
}