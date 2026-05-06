require 'prelude'

local name = fns 'electroboiler'

return {
    type = 'item',
    name = name,
    icons = {
        {
            icon = '__base__/graphics/icons/boiler.png',
            icon_size = 64,
            scale = 0.5
        },
        {
            icon = '__base__/graphics/icons/signal/signal-lightning.png',
            floating = true,
            icon_size = 64,
            scale = 0.5,
            tint = { r = 0.5, g = 0.5, b = 1 },
        }
    },
    subgroup = 'energy',
    order = 'b[steam-power]-a[electroboiler]',
    place_result = name,
    stack_size = 50,
}
