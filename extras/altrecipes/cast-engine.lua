require 'prelude'

return {
    {
        type = 'recipe',
        name = fns 'cast-engine',
        icons = {
            {
                icon=data.item['engine-unit'].icon,
                scale=0.5,
                shift={-4, 4},
                float=true
            },
            {
                icon='__FeedsNSpeeds__/graphics/icon/'
            }
        }
    }
}